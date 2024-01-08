# green_water_interview_test

## How to install

> Please install python 3.9

1. Install `pyenv` and `poetry`
2. `poetry env use python`
3. `poetry shell`
4. `poetry install`

Use `poetry export --format=requirements.txt --output requirements.txt` to generate requirements.txt

## How to run

1. run `docer compose -f postgrs_db_compose.yaml up -d` to start postgresql
2. run `init_sql.sql` to create database and table
3. run `python app.py` to start server
4. Use `green_test.postman_collection.json` to test API
