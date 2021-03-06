\name{traceplot-methods}
\docType{methods}
\alias{traceplot} 
\alias{traceplot,stanfit-method}

\title{\code{traceplot}: draw the traces of the sample}
\description{Draw the traceplot corresponding to one or more
 Markov chains, providing a visual way to inspect sampling behavior
 and assess mixing across chains and convergence.}

\usage{
  %% traceplot(object, \dots)  
  \S4method{traceplot}{stanfit}(object, pars, inc_warmup = TRUE, ask = FALSE,
    nrow = 4, ncol = 2, window = NULL, ...) 
} 

\section{Methods}{
  \describe{
    \item{traceplot}{\code{signature(object = "stanfit")}}{ Plot the traces of sample for all chains.}
  }
}

\arguments{
  \item{object}{An instance of class \code{\linkS4class{stanfit}}.}
  \item{pars}{A vector of character string specifying the  
      parameters to be plotted.} 
  \item{inc_warmup}{\code{TRUE} or \code{FALSE}, indicating whether 
    the warmup sample are included in the trace plot; defaults to \code{TRUE}}
  \item{ask}{\code{TRUE} or \code{FALSE}, to control (for the current device)
    whether the user is prompted before starting a new page of output in the case
    there are a lot of parameters (see \code{\link[grDevices]{devAskNewPage}}).}
  \item{nrow}{To specify the layout for the traceplots for multiple quantities: 
    number of rows on every page. Together with \code{ncol}, the layout would
    be nrow * ncol. The layout by specifying \code{nrow} and \code{ncol} takes
    effects only when the total number is larger than \code{nrow} times
    \code{ncol}.} 
  \item{ncol}{To specify the layout for the traceplots for multiple quantities: 
    number of columns on every page.} 
  \item{window}{To specify a window of all the iterations for plotting. 
    Default of NULL means plotting all iterations. \code{window} needs 
    to be an integer vector of at least length 1; smaller one specifies 
    the starting iteration and the bigger one the last iteration. When there
    is only one integer, it just indicates the starting iteration. Examples
    of specifying window: \code{window=100} and \code{window=c(100,1500)}.
  } 
  \item{\dots}{Additional parameters passed to the underlying function
    \code{plot}.} 
}
\value{\code{NULL}} 

\seealso{
  \code{\link[grDevices]{devAskNewPage}} 
}

\examples{\dontrun{
library(rstan) 
fit <- stan(model_code = "parameters {real y;} model {y ~ normal(0,1);}") 
traceplot(fit) 
}


# Create a stanfit object from reading CSV files of samples (saved in rstan
# package) generated by funtion stan for demonstration purpose from model as follows. 
# 
excode <- '
  transformed data {
    real y[20];
    y[1] <- 0.5796;  y[2]  <- 0.2276;   y[3] <- -0.2959; 
    y[4] <- -0.3742; y[5]  <- 0.3885;   y[6] <- -2.1585;
    y[7] <- 0.7111;  y[8]  <- 1.4424;   y[9] <- 2.5430; 
    y[10] <- 0.3746; y[11] <- 0.4773;   y[12] <- 0.1803; 
    y[13] <- 0.5215; y[14] <- -1.6044;  y[15] <- -0.6703; 
    y[16] <- 0.9459; y[17] <- -0.382;   y[18] <- 0.7619;
    y[19] <- 0.1006; y[20] <- -1.7461;
  }
  parameters {
    real mu;
    real<lower=0, upper=10> sigma;
    vector[2] z[3];
    real<lower=0> alpha;
  } 
  model {
    y ~ normal(mu, sigma);
    for (i in 1:3) 
      z[i] ~ normal(0, 1);
    alpha ~ exponential(2);
  } 
'
# exfit <- stan(model_code = excode, save_dso = FALSE, iter = 200, 
#               sample_file = "rstan_doc_ex.csv")
# 
exfit <- read_stan_csv(dir(system.file('misc', package = 'rstan'),
                       pattern='rstan_doc_ex_[[:digit:]].csv',
                       full.names = TRUE))

print(exfit)
## only print some parameters
print(exfit, pars = c("sigma", "alpha"))
traceplot(exfit)
traceplot(exfit, pars = "sigma")

## make traceplots of z[1,1], z[1,2], z[2,1], z[2,2]
traceplot(exfit, pars = paste0("z[", c(1, 1, 2, 2), ",", c(1, 2, 1, 2), "]"))
} 
\keyword{methods}
