import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Load the CSV file into a DataFrame
csv_file_path = './result_set_CSV_files/1_top_paying_jobs.csv'
data = pd.read_csv(csv_file_path)

# Plot the title and salary of the top 10 paying jobs using seaborn
plt.figure(figsize=(12, 6))
sns.barplot(x='avg_yearly_salary', y= 'job_title', hue='avg_yearly_salary', data=data, palette='Spectral')
plt.title('Top 10 Paying Non-Senior-Level Jobs')
plt.xlabel('Yearly Salary ($USD)')
plt.ylabel('Job Title')
plt.xticks(rotation=0, ha='center')
plt.legend().remove()
plt.tight_layout()

plt.savefig('assets/1_top_paying_jobs_histogram.png')