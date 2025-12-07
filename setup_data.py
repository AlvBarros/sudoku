import os
import pandas as pd
from datasets import load_dataset

ID = 'id'
GRID = 'puzzle'
SOLUTION = 'solution'
CLUES = 'clues'
DIFFICULTY = 'difficulty'

# Define the difficulty label column name
DIFFICULTY_LABEL = 'difficulty_label'

# Create data folder if it doesn't exist
print('Setting up data folder')
if not os.path.exists('data'):
    os.makedirs('data')
else:
    for file in os.listdir('data'):
        file_path = os.path.join('data', file)
        if os.path.isfile(file_path):
            os.remove(file_path)


# Load the new dataset from Hugging Face
print('Downloading and processing dataset')
dataset = load_dataset('sapientinc/sudoku-extreme')
df = pd.DataFrame(dataset['train'])
df.rename(columns={
    'source': ID,
    'question': GRID,
    'answer': SOLUTION,
    'rating': DIFFICULTY
}, inplace=True)

# Split the sorted DataFrame into 4 equal parts
difficulty_labels = ['easy', 'medium', 'hard', 'expert']
sorted_df = df.sort_values(by=DIFFICULTY).reset_index(drop=True)
split_indices = [len(sorted_df) // 4 * i for i in range(1, 4)]
sorted_df[DIFFICULTY_LABEL] = pd.cut(
    sorted_df.index,
    bins=[-1] + split_indices + [len(sorted_df) - 1],
    labels=difficulty_labels
)

# For each difficulty label, create a separate folder named after that difficulty
# Then create 10 JSON files for each 100 puzzles in that difficulty
for difficulty in sorted_df[DIFFICULTY_LABEL].unique():
    subset = sorted_df[sorted_df[DIFFICULTY_LABEL] == difficulty]
    subset = subset.sample(frac=1).reset_index(drop=True)
    subset = subset.head(1000)
    for i in range(10):
        print(f'Processing {difficulty} - file {i+1}')
        chunk = subset.iloc[i*100:(i+1)*100]
        chunk.to_json(f'data/{difficulty}_{i+1}.json', orient='records', lines=False)

print('Data setup complete.')