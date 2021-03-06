#' @title
#' Monte Carlo Simulation for the Triple Penance Rule
#'
#'@description
#'
#'The following process is simulated using the monte carlo process and the maximum drawdown is calculated using it.
#'\deqn{\triangle{\pi_{\tau}}=(1-\phi)\mu + \phi{\delta_{\tau-1}} + \sigma{\epsilon_{\tau}}}
#'
#'The random shocks are iid distributed \eqn{\epsilon_{\tau}~N(0,1)}. These random shocks follow an independent and 
#'identically distributed Gaussian Process, however \eqn{\triangle{\pi_\tau}} is neither an independent nor an 
#'identically distributed Gaussian Process. This is due to the parameter \eqn{\phi}, which incorporates a first-order 
#'serial-correlation effect of auto-regressive form. 
#'
#'
#' @param size size of the Monte Carlo experiment
#' @param phi AR(1) coefficient
#' @param mu unconditional mean
#' @param sigma Standard deviation of the random shock
#' @param dp0 Bet at origin (initialization of AR(1))
#' @param bets Number of bets in the cumulative process
#' @param confidence Confidence level for quantile
#' @author Pulkit Mehrotra
#' @references Bailey, David H. and Lopez de Prado, Marcos, Drawdown-Based Stop-Outs
#'  and the "Triple Penance" Rule(January 1, 2013).
#'  
#'  @examples
#'  MonteSimulTriplePenance(10^6,0.5,1,2,1,25,0.95) # Expected Value Quantile (Exact) = 6.781592
#'
#'@export  


 
MonteSimulTriplePenance<-function(size,phi,mu,sigma,dp0,bets,confidence){
  
  # DESCRIPTION:
  # The function gives Value of Maximum Drawdown generated by a monte carlo process. 
  
  # INPUTS:
  # The size, AR(1) coefficient, unconditional mean,  Standard deviation of the random shock,
  # Bet at origin (initialization of AR(1)), Number of bets in the cumulative process,Confidence level for quantile
  # are taken as the input
  
  # FUNCTION:
  q_value = getQ(bets, phi, mu, sigma, dp0, confidence)
  ms = numeric(size)
  delta = 0

  for(i in 1:size){
    pnl = 0
    delta = 0
    for(j in 1:bets){
      delta = (1-phi)*mu + rnorm(1)*sigma + delta*phi
      pnl = pnl +delta
    }
    ms[i] <- pnl
  }
  q_ms = quantile(ms,(1-confidence))
  diff = q_value - q_ms 
  result <- matrix(c(q_value,q_ms,diff),nrow = 3)
  rownames(result)= c("Exact","Monte Carlo","Difference")
  colnames(result) = "Quantile"
  return(result)
}



