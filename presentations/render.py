from pathlib import Path
from playwright.sync_api import sync_playwright
from PIL import Image, ImageOps, ImageDraw

root = Path(__file__).parent
with sync_playwright() as p:
    browser = p.chromium.launch(executable_path='/Applications/Google Chrome.app/Contents/MacOS/Google Chrome', headless=True)
    page = browser.new_page(viewport={'width':1600,'height':900}, device_scale_factor=1)
    page.goto((root/'FeelIt-Product-HE.html').as_uri())
    page.evaluate('document.fonts.ready')
    page.pdf(path=str(root/'FeelIt-Product-HE.pdf'), width='1600px', height='900px', print_background=True, prefer_css_page_size=True)
    overflow = page.evaluate('''() => [...document.querySelectorAll('section > div')].filter(e => e.scrollHeight > e.clientHeight + 3 || e.scrollWidth > e.clientWidth + 3).map(e=>({text:e.innerText,scroll:e.scrollHeight,height:e.clientHeight}))''')
    (root/'layout-check.txt').write_text(str(overflow))
    shots=[]
    for i, section in enumerate(page.locator('section').all()):
        target=root/f'slide-{i+1:02}.png'
        section.screenshot(path=str(target))
        img=Image.open(target).convert('RGB'); img.thumbnail((480,270)); shots.append(img)
    sheet=Image.new('RGB',(480*4,300*5),'#dedde3')
    draw=ImageDraw.Draw(sheet)
    for i,img in enumerate(shots):
        x=(i%4)*480; y=(i//4)*300
        sheet.paste(img,(x,y)); draw.text((x+8,y+276),str(i+1),fill='black')
    sheet.save(root/'contact-sheet.jpg')
    browser.close()
