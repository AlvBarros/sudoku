import os
import pandas as pd

ID = 'id'
GRID = 'puzzle'
SOLUTION = 'solution'
CLUES = 'clues'
DIFFICULTY = 'difficulty'

# Create data folder if it doesn't exist
if not os.path.exists('data'):
    os.makedirs('data')

# Check if `puzzles.csv` already exists
if not os.path.exists('puzzles.csv'):    
    # Temporarily download raw data from Kaggle
    # https://www.kaggle.com/datasets/radcliffe/3-million-sudoku-puzzles-with-ratings
    import kaggle
    from kaggle.api.kaggle_api_extended import KaggleApi
    api = KaggleApi()
    api.authenticate()
    api.dataset_download_files('radcliffe/3-million-sudoku-puzzles-with-ratings', unzip=True)

    # Read the CSV file
    df = pd.read_csv('sudoku-3m.csv').drop_duplicates(subset=[GRID])

    # Break the difficulties into bins
    DIFFICULTY_LABEL = 'difficulty_label'
    min_diff = df[DIFFICULTY].min()
    max_diff = df[DIFFICULTY].max()
    difficulty_bins = [min_diff, 0.25 * max_diff, 0.5 * max_diff, 0.75 * max_diff, max_diff]
    difficulty_labels = ['easy', 'medium', 'hard', 'expert']
    df[DIFFICULTY_LABEL] = pd.cut(df[DIFFICULTY], bins=difficulty_bins, labels=difficulty_labels, include_lowest=True)

    # Save the processed data to a new CSV file
    df.to_csv('puzzles.csv', index=False)

df = pd.read_csv('puzzles.csv')
DIFFICULTY_LABEL = 'difficulty_label'

# For each difficulty label, create a separate folder named after that difficulty
# Then create 10 JSON files for each 100 puzzles in that difficulty
# e.g., data/easy/1.json, data/easy/2.json, ...
for difficulty in df[DIFFICULTY_LABEL].unique():
    subset = df[df[DIFFICULTY_LABEL] == difficulty]
    subset = subset.sample(frac=1).reset_index(drop=True)
    subset = subset.head(1000)
    for i in range(10):
        print(f'Processing {difficulty} - file {i+1}')
        chunk = subset.iloc[i*100:(i+1)*100]
        chunk.to_json(f'data/{difficulty}_{i+1}.json', orient='records', lines=False)

# Delete the temporary CSV file
os.remove('sudoku-3m.csv')
os.remove('puzzles.csv')

print('Data setup complete.')