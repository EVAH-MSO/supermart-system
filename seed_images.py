import pymysql, os

# Curated Unsplash/Pexels URLs — one per product
IMAGES = {
    'Unga 2kg':          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
    'Rice 2kg':          'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
    'Maize Flour 1kg':   'https://images.unsplash.com/photo-1626200419199-391ae4be7a41?w=400',
    'Wheat Flour 2kg':   'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
    'Spaghetti 500g':    'https://images.unsplash.com/photo-1551462147-ff29053bfc14?w=400',
    'Macaroni 500g':     'https://images.unsplash.com/photo-1551462147-ff29053bfc14?w=400',
    'Millet Flour 1kg':  'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
    'Sorghum Flour 1kg': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
    'Cassava Flour 1kg': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
    'Oats 500g':         'https://images.unsplash.com/photo-1517093602195-8fefb3b1e0c5?w=400',

    'Cooking Oil 1L':    'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
    'Cooking Oil 3L':    'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
    'Vegetable Oil 2L':  'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
    'Coconut Oil 500ml': 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=400',
    'Ghee 500g':         'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=400',
    'Margarine 500g':    'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=400',
    'Olive Oil 250ml':   'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
    'Sunflower Oil 1L':  'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
    'Palm Oil 1L':       'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
    'Cooking Fat 1kg':   'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=400',

    'Sugar 1kg':         'https://images.unsplash.com/photo-1581351721010-8cf859cb14a4?w=400',
    'Sugar 2kg':         'https://images.unsplash.com/photo-1581351721010-8cf859cb14a4?w=400',
    'Honey 500g':        'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400',
    'Mumias Sugar 1kg':  'https://images.unsplash.com/photo-1581351721010-8cf859cb14a4?w=400',
    'Brown Sugar 1kg':   'https://images.unsplash.com/photo-1581351721010-8cf859cb14a4?w=400',
    'Glucose 500g':      'https://images.unsplash.com/photo-1581351721010-8cf859cb14a4?w=400',
    'Molasses 500g':     'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400',
    'Sweetener Tablets':'https://images.unsplash.com/photo-1581351721010-8cf859cb14a4?w=400',
    'Sugar Cubes 500g':  'https://images.unsplash.com/photo-1581351721010-8cf859cb14a4?w=400',
    'Icing Sugar 500g':  'https://images.unsplash.com/photo-1581351721010-8cf859cb14a4?w=400',

    'Tea Leaves 250g':   'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=400',
    'Coffee 200g':       'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=400',
    'Milo 400g':         'https://images.unsplash.com/photo-1517093602195-8fefb3b1e0c5?w=400',
    'Cocoa 200g':        'https://images.unsplash.com/photo-1517093602195-8fefb3b1e0c5?w=400',
    'Juice 1L':          'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400',
    'Soda 500ml':        'https://images.unsplash.com/photo-1581636625402-29b2a704ef13?w=400',
    'Water 5L':          'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400',
    'Milk 500ml':        'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',
    'UHT Milk 1L':       'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',
    'Yoghurt 500ml':     'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',

    'Soap 800g':         'https://images.unsplash.com/photo-1600857544200-b2f666a9a2ec?w=400',
    'Detergent 1kg':     'https://images.unsplash.com/photo-1610557892470-55d9e80c0bce?w=400',
    'Bleach 1L':         'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=400',
    'Toothpaste 100g':   'https://images.unsplash.com/photo-1607613009820-a29f7bb81c04?w=400',
    'Tissue 10pk':       'https://images.unsplash.com/photo-1584556812952-905ffd0c611a?w=400',
    'Sponge':            'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=400',
    'Scrub Pad':         'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=400',
    'Dish Soap 500ml':   'https://images.unsplash.com/photo-1610557892470-55d9e80c0bce?w=400',
    'Air Freshener':     'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=400',
    'Floor Cleaner 1L':  'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=400',
}

conn = pymysql.connect(
    host=os.environ['DB_HOST'], port=int(os.environ['DB_PORT']),
    user=os.environ['DB_USER'], password=os.environ['DB_PASS'],
    database=os.environ['DB_NAME'],
)
cur = conn.cursor()
updated = 0
for name, url in IMAGES.items():
    cur.execute("UPDATE products SET image_url=%s WHERE name=%s", (url, name))
    updated += cur.rowcount
conn.commit()

cur.execute("SELECT COUNT(*) FROM products WHERE image_url IS NOT NULL")
print(f"Updated {updated} rows, {cur.fetchone()[0]} products now have images")
conn.close()
