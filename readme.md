# 1. Install dependencies
pip install -r requirements.txt

# 2. Create database structure
python app/init_db.py # Check the credentials in `db.py` 

# 3. Populate initial data
python app/init_data.py

# 4. Start the application
python main.py

