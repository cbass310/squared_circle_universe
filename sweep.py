import os, re

base_dir = 'lib'
counter = 500000
id_map = {}

def repl(match):
    global counter
    val_str = match.group(0)
    if val_str not in id_map:
        counter += 1
        id_map[val_str] = str(counter)
    return id_map[val_str]

files_to_process = []
for root, _, files in os.walk(base_dir):
    for file in files:
        if file.endswith('.dart'):
            files_to_process.append(os.path.join(root, file))

files_to_process.sort()  # Ensures deterministic mapping across runs

for filepath in files_to_process:
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Replace all 16+ digit sequences with mapped 6-digit IDs
    new_content = re.sub(r'\b\d{16,}\b', repl, content)
    
    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f'Cleaned massive integers in: {filepath}')
