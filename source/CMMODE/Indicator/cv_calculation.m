function CV=cv_calculation(obtained_cons)
 CV = sum(max(0,obtained_cons),2);
 CV=mean(CV,1);