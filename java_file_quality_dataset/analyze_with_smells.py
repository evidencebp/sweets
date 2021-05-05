import pandas as pd

ds = pd.read_csv('java_file_quality_dataset.csv')
df = pd.read_csv('hotspots_agg_1_1_2019.csv')

ds['project'] = ds.repo_name.map(lambda x: x.split('/')[1])
df['just_file'] = df.file.map(lambda x: x[x.find('/') + 1:] + '.java')
m = pd.merge(ds, df, left_on=['project', 'file'], right_on=['repository', 'just_file'])
m.to_csv('file_quality_1_1_2019_smells.csv', index=False)

m['is_short'] = m.LineLength.map( lambda x: x <=104)
m.groupby([ 'high_ccp_quality', 'is_short'], as_index=False).agg({'repo_name': 'count'})

m['no_sig_smell'] = m.apply(lambda x: (x.NPathComplexity == 0)
        & (x.FallThrough == 0)
        # | ((df.JavadocParagraph > 0 ) & ( df.JavadocParagraph < 3))
        # | ((df.TrailingComment > 0 ) & ( df.TrailingComment < 3))
        & (x.IllegalImport == 0)
        & (x.AvoidStaticImport == 0)
        & (x.IllegalCatch == 0)
        & (x.ParameterAssignment == 0)
        & (x.UnnecessaryParentheses== 0)
        , axis=1)

m.groupby(['high_ccp_quality', 'no_sig_smell'], as_index=False).agg({'repo_name': 'count'})
