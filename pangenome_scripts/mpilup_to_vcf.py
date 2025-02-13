pile = pd.read_csv("All_try_cov1_var.tsv", sep="\t", header=None)
pile["keep"] = pile.iloc[:, 3:36].apply(lambda x: len(x.value_counts()), axis=1)
pile = pile[pile.keep <= 3]
for ncol in range(33):
	pile.loc[(pile.loc[:,ncol + 3] != "0") & (pile.loc[:,ncol + 3] != 0), ncol + 3] = 1
pile.insert(loc=2, column='ID', value=".")
pile.insert(loc=4, column='ALT', value="A")
pile.loc[:,2] = "T"
pile.insert(loc=5, column='QUAL', value=1000)
pile.insert(loc=6, column='FILTER', value=".")
pile.insert(loc=7, column='INFO', value=".")
pile.insert(loc=8, column='FORMAT', value="GT")
pile.iloc[:,:42].to_csv("All_try_cov1.vcf", sep="\t", index=False)
