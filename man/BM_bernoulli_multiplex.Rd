\name{BM_bernoulli_multiplex}
\alias{BM_bernoulli_multiplex}
\alias{\S4method{BM_bernoulli_multiplex}{new}}
\title{Perform estimation on blockmodels for multiplex binary networks}
\description{
    With the provided network and blockmodel type, estimate number of groups,
parameters and node membership}
\usage{\S4method{BM_bernoulli_multiplex}{new}(
    membership_type, 
    adj, 
    verbosity=6,
    autosave='',
    plotting=character(0),
    exploration_factor=1.5,
    explore_min=4,
    explore_max=Inf,
    ncores=detectCores())}
\arguments{
    \item{membership_type}{The type of node membership, i.e. 'SBM', 'SBM_sym' or 'LBM'}
    \item{adj}{The list of adjacency matrices. All matrices must have the same size}
    \item{verbosity}{The verbosity level, 0 means quiet. Level 1 display the phase of reinitialization. Level 2 display the level 1 and the ascending and descending phase for the number of groups. Level 3 display the level 2 and the number current number of groups which is estimated. Level 4 display the level 3 and the steps inside the estimation. Level 5 display the level 4, the current status of parallel running jobs and the current sub-step. Level 6 display level 5 and informations about ICL criteria found. Default is level 6. This parameter can be changed by accessing to the field $verbosity of the object.}
\item{autosave}{If \var{autosave} != '', after each estimation, the model object is writed into file \var{autosave}. The model object is readable by the function \var{readRDS}. Use-it for long computation to allow restarting the estimation on system crash. You can use it to alanyze the partial results when the estimation is running. This parameter can be changed by accessing to the field $autosave of the object.}
\item{plotting}{Control plot of ICL values while the estimation is running. If plotting==character(0) (the default), plots are done on screen, if plotting=='', no plot are done, if plotting is a filename, plots are done in this filename. This parameter can be changed by accessing the field $plotting of the object.}\item{exploration_factor}{Control the exploration of the number of groups. The exploration is stop when the number of groups reach exploration factor times the current maximum. By default 1.5. This parameter can be changed by accessing the field $exploration_factor of the object.}
\item{explore_min}{Explore to the explore_min number of groups even if the exploration_factor rule is satisfied. By default 4. This parameter can be changed by accessing the field $explore_min of the object.}
\item{explore_max}{Stop exploration after explore_max number of group in any case. By default Inf. This parameter can be changed by accessing the field $explore_max of the object.}
\item{ncores}{Number of parallel jobs to launch different EM intializations. By default detectCores(). This parameter can be changed by accessing the field $ncores of the object. This parameters is used only on Linux. Parallism is disabled on other plateform. (Not working on Windows, not tested on Mac OS, not tested on *BSD.)}

}
\examples{\dontrun{

##
## SBM
##

## generation of one SBM network
npc <- 30 # nodes per class
Q <- 3 # classes
n <- npc * Q # nodes
Z<-diag(Q)\%x\%matrix(1,npc,1)
Q <- 3 # classes
n <- npc * Q # nodes
Z<-diag(Q)\%x\%matrix(1,npc,1)
P00<-matrix(runif(Q*Q),Q,Q)
P10<-matrix(runif(Q*Q),Q,Q)
P01<-matrix(runif(Q*Q),Q,Q)
P11<-matrix(runif(Q*Q),Q,Q)
SumP<-P00+P10+P01+P11
P00<-P00/SumP
P01<-P01/SumP
P10<-P10/SumP
P11<-P11/SumP
MU<-matrix(runif(n*n),n,n)
M1<-1*(MU>Z\%*\%(P00+P01)\%*\%t(Z))
M2<-1*((MU>Z\%*\%P00\%*\%t(Z)) & (MU<Z\%*\%(P00+P01+P11)\%*\%t(Z))) ## adjacency matrices


## estimation
my_model <- BM_bernoulli_multiplex("SBM",list(M1,M2) )
my_model$estimate()
which.max(my_model$ICL)

##
## SBM symmetric
##

## generation of one SBM network
npc <- 30 # nodes per class
Q <- 3 # classes
n <- npc * Q # nodes
Z<-diag(Q)\%x\%matrix(1,npc,1)
Q <- 3 # classes
n <- npc * Q # nodes
Z<-diag(Q)\%x\%matrix(1,npc,1)
P00<-matrix(runif(Q*Q),Q,Q)
P10<-matrix(runif(Q*Q),Q,Q)
P01<-matrix(runif(Q*Q),Q,Q)
P11<-matrix(runif(Q*Q),Q,Q)
SumP<-P00+P10+P01+P11
P00<-P00/SumP
P01<-P01/SumP
P10<-P10/SumP
P11<-P11/SumP
P00[lower.tri(P00)]<-t(P00)[lower.tri(P00)]
P01[lower.tri(P01)]<-t(P01)[lower.tri(P01)]
P10[lower.tri(P10)]<-t(P10)[lower.tri(P10)]
P11[lower.tri(P11)]<-t(P11)[lower.tri(P11)]
MU<-matrix(runif(n*n),n,n)
MU[lower.tri(MU)]<-t(MU)[lower.tri(MU)]
M1<-1*(MU>Z\%*\%(P00+P01)\%*\%t(Z))
M2<-1*((MU>Z\%*\%P00\%*\%t(Z)) & (MU<Z\%*\%(P00+P01+P11)\%*\%t(Z))) ## adjacency matrices


## estimation
my_model <- BM_bernoulli_multiplex("SBM_sym",list(M1,M2) )
my_model$estimate()
which.max(my_model$ICL)


##
## LBM
##

## generation of one LBM network
npc <- c(50,40) # nodes per class
Q <- c(2,3) # classes
n <- npc * Q # nodes
Z1<-diag(Q[1])\%x\%matrix(1,npc[1],1)
Z2<-diag(Q[2])\%x\%matrix(1,npc[2],1)
P00<-matrix(runif(Q[1]*Q[2]),Q[1],Q[2])
P10<-matrix(runif(Q[1]*Q[2]),Q[1],Q[2])
P01<-matrix(runif(Q[1]*Q[2]),Q[1],Q[2])
P11<-matrix(runif(Q[1]*Q[2]),Q[1],Q[2])
SumP<-P00+P10+P01+P11
P00<-P00/SumP
P01<-P01/SumP
P10<-P10/SumP
P11<-P11/SumP
MU<-matrix(runif(n[1]*n[2]),n[1],n[2])
M1<-1*(MU>Z1\%*\%(P00+P01)\%*\%t(Z2))
M2<-1*((MU>Z1\%*\%P00\%*\%t(Z2)) & (MU<Z1\%*\%(P00+P01+P11)\%*\%t(Z2))) ## adjacency matrices


## estimation
my_model <- BM_bernoulli_multiplex("LBM",list(M1,M2) )
my_model$estimate()
which.max(my_model$ICL)
}}
