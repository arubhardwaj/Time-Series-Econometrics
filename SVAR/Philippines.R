## Introduction

[Blanchard & Quah (1989)](https://uh.edu/~bsorense/BlanchardQuah1989.pdf) developed an interesting framework for interpreting the Structural Vector Autoregression models. Using the ``vars`` package in R, here I replicate the codes from the Blog post, [Eloriaga (2020)](https://levelup.gitconnected.com/structural-vector-autoregression-in-r-5d6dbfc56499), to study it from the framework developed by Blanchard and Quah (1989). Thanks to the available information on the blog, through which I got the access to data used in the post. However, the blog post was only for an introduction to SVARs, extending it to further, I used Blanchard & Quah (1989) type SVAR here.

Note: Data used here was available through the Google drive on the Blog post.

At first, the needed packages to do this are ``vars``, `tseries`, `svars` and `TSstudio`.

```{r, include=FALSE, results='hide'}
install.packages('vars')
library(vars)
install.packages('tseries')
library(tseries)
install.packages('svars')
library(svars)
install.packages('TSstudio')
library(TSstudio)
data<-read.csv("/cloud/project/Philippine_SVAR.csv", head=TRUE)
```

## Converting Data in the Time Series

The following commands are necessay for converting the data in the time series. The plot of out time series data is:
  
  ```{r}
y <- ts(data$Output.Gap, start = c(2000, 1, 1), frequency = 4)
inf<- ts(data$CPI, start = c(2000, 1, 1), frequency = 4)
r <- ts(data$RRP, start = c(2000,1,1), frequency =4)
sv <- cbind(y, inf, r)

plot.ts(sv)
```

**Please note:** ``y`` is Output Gap, ``inf`` is Inflation Rate and ``r`` is Overnight Reverse Repurchase Rate.

## Determine the number of lags

For determining the number of labs, for our VAR model, we'd require the lag value, which, in this case, is **5**.

```{r}
lagselect <- VARselect(sv, lag.max = 8, type = "both")
lagselect$selection
```


## Vector Autoregression Model

The following model will give us the VAR results.

```{r}
VARmodel <- VAR(sv, lag.max = 5, type = 'const', season = NULL, exogen = NULL)
summary(VARmodel)
```

## Blanchard and Quah (1989) type SVAR model

Once we have our VAR model, we can pue ``BQ()`` function for estimating the Blanchard & Quah (1989) type SVAR results. Which, in this case, are as follows:

```{r}
BQ<-BQ(VARmodel)
summary(BQ)
```

## Impulse Response Functions and the Forecast Error Variance Decompositions

### IRF

This is the most important step in our model, because in this step we seek the results which we need to use. For estimating the Impulsive Response Function, I use use ``irf()`` function and plot it accordingly.

```{r}
irf1 <- irf(BQ, impulse = 'y', response = 'y')
plot(irf1)

irf2 <- irf(BQ, impulse = 'y', response = 'inf')
plot(irf2)


irf3 <- irf(BQ, impulse = 'y', response = 'r')
plot(irf3)
```

### Forcasting and FEVD

Here, I forcast the values of 20 further quarters.

```{r}
fevd <- fevd(BQ, n.ahead = 20)
plot(fevd)
```

As you can see, the results are totally different from what were interpreted by the traditional SVAR model. Through the traditional model, it was interpreted that output is explained by output only, but, here, RRP and inflation are also affecting it.

## References

Blanchard, Olivier Jean & Quah, Danny, 1989. [The Dynamic Effects of Aggregate Demand and Supply Disturbances](https://uh.edu/~bsorense/BlanchardQuah1989.pdf), American Economic Review, American Economic Association. (Last accessed: 26 July, 2020)

Eloriga, Justin, 2020. [Introduction to the Structural Vector Autoregression](https://levelup.gitconnected.com/structural-vector-autoregression-in-r-5d6dbfc56499), Level Up Coding by Gitconnected. (Last accessed: 26 July, 2020)

