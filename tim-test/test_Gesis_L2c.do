cd "\\ad.ucl.ac.uk\homem\rmjltnm\Documents\siman"
use tim-test\estimates_L2c_built, clear
drop omega sigma

siman setup , rep(id_rep) dgm(dgm) method(method) estimate(alpha beta) se(alpha_se beta_se)
