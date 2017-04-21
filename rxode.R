# 설치하기
install.packages("RxODE")

# Differential Equation으로 모형 설정
ode <- "
C2 = centr/V2;
C3 = peri/V3;
d/dt(depot) =-KA*depot;
d/dt(centr) = KA*depot - CL*C2 - Q*C2 + Q*C3;
d/dt(peri) = Q*C2 - Q*C3;
d/dt(eff) = Kin - Kout*(1-C2/(EC50+C2))*eff;
"
# 라이브러리 불러오고, 모형을 적용하기.
library(RxODE)
work <- tempfile("Rx_intro-")
mod1 <- RxODE(model = ode, modName = "mod1", wd = work)

# Theta 값 설정
theta <-
    c(KA=2.94E-01, CL=1.86E+01, V2=4.02E+01, # central
      Q=1.05E+01, V3=2.97E+02, # peripheral
      Kin=1, Kout=1, EC50=200) # effects

# 각 compartment의 초기상태 설정
inits <- c(depot=0, centr=0, peri=0, eff=1)

# 비어있는 event table을 생성함.
ev <- eventTable(amount.units='mg', time.units='hours')

# 10 mg BID for 5 days. 이후 20 mg QD for 5 days 
# 1시간마다 sampling 하는 것으로 함.
ev$add.dosing(dose=10000, nbr.doses=10, dosing.interval=12)
ev$add.dosing(dose=20000, nbr.doses=5, start.time=120, dosing.interval=24)
ev$add.sampling(0:240)

# event table로부터 정보를 가져오기 (dosing, sampling)
head(ev$get.dosing())
## time evid amt
## 1 0 101 10000
## 2 12 101 10000
## 3 24 101 10000
## 4 36 101 10000
## 5 48 101 10000
## 6 60 101 10000

head(ev$get.sampling())
## time evid amt
## 16 0 0 NA
## 17 1 0 NA
## 18 2 0 NA
## 19 3 0 NA
## 20 4 0 NA
## 21 5 0 NA

# Simulation 실행하기. simulation 결과를 matrix x에 저장한다.
x <- mod1$solve(theta, ev, inits)
head(x)
## time depot centr peri eff C2 C3
## [1,] 0 10000.000 0.000 0.0000 1.000000 0.00000 0.0000000
## [2,] 1 7452.765 1783.897 273.1895 1.084664 44.37555 0.9198298
## [3,] 2 5554.370 2206.295 793.8758 1.180825 54.88296 2.6729825
## [4,] 3 4139.542 2086.518 1323.5783 1.228914 51.90343 4.4564927
## [5,] 4 3085.103 1788.795 1776.2702 1.234610 44.49738 5.9807076
## [6,] 5 2299.255 1466.670 2131.7169 1.214742 36.48434 7.1774981

# Plot으로 보여주기
par(mfrow=c(1,2))
matplot(x[,"C2"], type="l", ylab="Central Concentration")
matplot(x[,"eff"], type="l", ylab = "Effect")
# Plot 이 나온다~~
