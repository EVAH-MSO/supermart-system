-- =====================================================
-- SuperMart — SEED DATA
-- Sample data for the app database.
-- =====================================================

-- ---------- STORES (10 Kenyan towns) ----------
INSERT INTO stores (name, city, region) VALUES
('Nairobi CBD', 'Nairobi', 'Central'),
('Westlands', 'Nairobi', 'Central'),
('Mombasa Nyali', 'Mombasa', 'Coast'),
('Mombasa Likoni', 'Mombasa', 'Coast'),
('Kisumu Main', 'Kisumu', 'Nyanza'),
('Nakuru Town', 'Nakuru', 'Rift Valley'),
('Eldoret CBD', 'Eldoret', 'Rift Valley'),
('Thika Road', 'Nairobi', 'Central'),
('Malindi', 'Malindi', 'Coast'),
('Kericho', 'Kericho', 'Rift Valley');

-- ---------- PRODUCTS (50 items, 5 categories) ----------
INSERT INTO products (name, category, price) VALUES
-- Staples
('Unga 2kg', 'Staples', 180),
('Rice 2kg', 'Staples', 280),
('Maize Flour 1kg', 'Staples', 120),
('Wheat Flour 2kg', 'Staples', 200),
('Spaghetti 500g', 'Staples', 95),
('Macaroni 500g', 'Staples', 90),
('Millet Flour 1kg', 'Staples', 130),
('Sorghum Flour 1kg', 'Staples', 125),
('Cassava Flour 1kg', 'Staples', 140),
('Oats 500g', 'Staples', 160),

-- Cooking
('Cooking Oil 1L', 'Cooking', 350),
('Cooking Oil 3L', 'Cooking', 950),
('Vegetable Oil 2L', 'Cooking', 620),
('Coconut Oil 500ml', 'Cooking', 480),
('Ghee 500g', 'Cooking', 520),
('Margarine 500g', 'Cooking', 300),
('Olive Oil 250ml', 'Cooking', 550),
('Sunflower Oil 1L', 'Cooking', 380),
('Palm Oil 1L', 'Cooking', 320),
('Cooking Fat 1kg', 'Cooking', 280),

-- Sweeteners
('Sugar 1kg', 'Sweeteners', 150),
('Sugar 2kg', 'Sweeteners', 290),
('Honey 500g', 'Sweeteners', 750),
('Mumias Sugar 1kg', 'Sweeteners', 160),
('Brown Sugar 1kg', 'Sweeteners', 170),
('Glucose 500g', 'Sweeteners', 210),
('Molasses 500g', 'Sweeteners', 220),
('Sweetener Tablets', 'Sweeteners', 350),
('Sugar Cubes 500g', 'Sweeteners', 180),
('Icing Sugar 500g', 'Sweeteners', 190),

-- Beverages
('Tea Leaves 250g', 'Beverages', 200),
('Coffee 200g', 'Beverages', 480),
('Milo 400g', 'Beverages', 620),
('Cocoa 200g', 'Beverages', 380),
('Juice 1L', 'Beverages', 180),
('Soda 500ml', 'Beverages', 70),
('Water 5L', 'Beverages', 120),
('Milk 500ml', 'Beverages', 60),
('UHT Milk 1L', 'Beverages', 110),
('Yoghurt 500ml', 'Beverages', 150),

-- Household
('Soap 800g', 'Household', 220),
('Detergent 1kg', 'Household', 320),
('Bleach 1L', 'Household', 180),
('Toothpaste 100g', 'Household', 190),
('Tissue 10pk', 'Household', 350),
('Sponge', 'Household', 50),
('Scrub Pad', 'Household', 40),
('Dish Soap 500ml', 'Household', 160),
('Air Freshener', 'Household', 280),
('Floor Cleaner 1L', 'Household', 250);

-- ---------- CUSTOMERS (20) ----------
INSERT INTO customers (name, city) VALUES
('John Kamau', 'Nairobi'),
('Mary Wanjiku', 'Mombasa'),
('Peter Otieno', 'Kisumu'),
('Grace Achieng', 'Nairobi'),
('David Mwangi', 'Nakuru'),
('Sarah Njoroge', 'Nairobi'),
('James Ochieng', 'Kisumu'),
('Faith Wafula', 'Eldoret'),
('Paul Kipchoge', 'Eldoret'),
('Mercy Cheruiyot', 'Kericho'),
('Samuel Mutua', 'Mombasa'),
('Esther Odhiambo', 'Kisumu'),
('Daniel Kimani', 'Nairobi'),
('Ruth Njeri', 'Nakuru'),
('Joseph Barasa', 'Eldoret'),
('Hannah Wambui', 'Nairobi'),
('Michael Omondi', 'Kisumu'),
('Naomi Chebet', 'Kericho'),
('Stephen Maina', 'Nairobi'),
('Joy Adhiambo', 'Mombasa');
