import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Load the CSV file into a DataFrame
csv_file_path = './result_set_CSV_files/2_top_paying_job_skills.csv'
data = pd.read_csv(csv_file_path)

# Replace 'react.js' with 'react' in the 'required_skill' column
data['required_skill'] = data['required_skill'].replace('react.js', 'react')

# Count the frequency of each skill in the 'required_skill' column
skill_counts = data['required_skill'].value_counts().reset_index()
skill_counts.columns = ['required_skill', 'frequency']

# Sort by frequency and select top skills for visualization
top_10_skills = skill_counts.nlargest(15, 'frequency')

# Plot using seaborn
plt.figure(figsize=(12, 6))
sns.barplot(x='required_skill', y='frequency', hue="required_skill", data=top_10_skills, palette='Spectral')
plt.title('Frequency of Skills in the Top 10 Paying Job Listings')
plt.xlabel('Skill')
plt.ylabel('Frequency')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()

plt.savefig('assets/2_skill_frequency_histogram.png')