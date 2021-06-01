# Java File Quality Data Set

This data set should enable end-to-end learning, starting from source code and predicting code quality.

**Note that this data set is still under construction.**

The quality is measured using ["The Corrective Commit Probability Code Quality Metric"](https://arxiv.org/abs/2007.10912).
In order to have a source code version whose quality is stable, we would like to use the January 1st 2019 version.
We use files that either had high quality or low quality during 2019 and 2020.

Currently we provide the source code version of May 6th 2021, which is likely to be different.
We publish it in order to enable experimenting with the direction for the meanwhile.

We also provide benchmarks to estimate the result of the end to end approach.
We provide the results of using prior year quality as a predictor, file length and the existence of likely harmful smells, found in ["Follow Your Nose -- Which Code Smells are Worth Chasing?"](https://arxiv.org/pdf/2103.01861.pdf).

The content of the data set files that changed by June 1st 2021 is in contents_diff_1_june_2021.csv.zip
There are 1,797 such files, out of 12,486 file in the data set.
Pairing the versions of the same file as positives
and comparing them to random different files as negatives enable to learn code similarity.
