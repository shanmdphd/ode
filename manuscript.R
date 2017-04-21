#Define model

ode <- "

C2=centr/V2;

C3=peri/V3;

d/dt(depot)=-KA*depot;

d/dt(centr)=KA*depot - CL*C2 - Q*C2+Q*C3;

d/dt(peri)=Q*C2 - Q*C3;

d/dt(eff)=Kin - Kout*(1-C2/(EC50+C2))*eff;

"


# Define parameters and initial conditions
params <- c(KA=0.3, CL=7, V2=40, Q=10, V3=300, Kin=0.2, Kout=0.2, EC50=8)

inits <- c(0, 0, 0, 1)

# Compile model
mod1 <- RxODE(model = ode, modName = "mod1")
# Run simulation
x <- mod1$run(params, ev, inits)

X <- mod1$run(theta, ev, inits, stiff5F, atol51e-8,
            rtol51e-6)

# Run simulation

x <- mod1$run(params, ev, inits)
?RxODE
