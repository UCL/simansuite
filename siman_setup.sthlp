{smcl}
{* *! version 0.4 14feb2022}{...}
{vieweralsosee "Main siman help page" "siman"}{...}
{viewerjumpto "Data formats" "siman_setup##data"}{...}
{viewerjumpto "Syntax" "siman_setup##syntax"}{...}
{viewerjumpto "Description" "siman_setup##description"}{...}
{viewerjumpto "Examples" "siman_setup##examples"}{...}
{viewerjumpto "Authors" "siman_setup##authors"}{...}

{title:Title}

{p2colset 5 15 17 2}{...}
{p2col :{hi:siman setup} - Prepare data for siman suite}{p_end}
{p2colreset}{...}

{marker data}{...}
{title:Data formats}

{pstd}
Input data can be either in:

{pstd}
(1) long-long format (i.e. long targets, long methods)

{pstd}
(2) wide-wide format

{pstd}
(3) long-wide format (i.e. long targets, wide methods), or

{pstd}
(4) wide-long format (i.e. wide targets, long methods).

{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmdab:siman setup}
{ifin}
{cmd:,}
{opt r:ep(varname)}
[{cmd:}
{it:options}
]


{p 8 12 2}
Options for data in long-long input format (data format 1):

{p 8 12 2}
{opt dgm(varlist)}
{opt tar:get(varname)}
{opt meth:od(varname)}
{opt est:imate(varname)}
{opt se(varname)}
{opt df(varname)}
{opt lci(varname)}
{opt uci(varname)}
{opt p(varname)}
{opt true(#|varname)}
clear

{p 8 12 2}
Options for data in wide-wide input format (data format 2):

{p 8 12 2}
{opt dgm(varlist)}
{opt tar:get(values)}
{opt meth:od(values)}
{opt est:imate(stub_varname)}
{opt se(stub_varname)}
{opt df(stub_varname)}
{opt lci(stub_varname)}
{opt uci(stub_varname)}
{opt p(stub_varname)}
{opt true(#|stub_varname)}
{opt ord:er(varname)}
clear

{p 8 12 2}
Options for data in long-wide input format (data format 3):

{p 8 12 2}
{opt dgm(varlist)}
{opt tar:get(varname)}
{opt meth:od(values)}
{opt est:imate(stub_varname)}
{opt se(stub_varname)}
{opt df(stub_varname)}
{opt lci(stub_varname)}
{opt uci(stub_varname)}
{opt p(stub_varname)}
{opt true(#|stub_varname)}
clear

{p 8 12 2}
Options for data in wide-long input format (data format 4):

{p 8 12 2}
{opt dgm(varlist)}
{opt tar:get(values)}
{opt meth:od(varname)}
{opt est:imate(stub_varname)}
{opt se(stub_varname)}
{opt df(stub_varname)}
{opt lci(stub_varname)}
{opt uci(stub_varname)}
{opt p(stub_varname)}
{opt true(#|stub_varname)}
clear
 
 
{synoptset 35 tabbed}{...}
{synopthdr}
{synoptline}

{synopt:{opt dgm(varlist)}}data generating mechanism.{p_end}
{synopt:{opt tar:get(varname|values)}}the target variable name or values.{p_end}
{synopt:{opt meth:od(varname|values)}}the method variable name or values.{p_end}
{synopt:{opt est:imate(varname|stub_varname)}}the estimate variable name or the name of it's stub if in wide format.{p_end}
{synopt:{opt se(varname|stub_varname)}}the standard error variable name or the name of it's stub if in wide format.{p_end}
{synopt:{opt df(varname|stub_varname)}}the degrees of freedom variable name or the name of it's stub if in wide format.{p_end}
{synopt:{opt lci(varname|stub_varname)}}the lower confidence interval variable name or the name of it's stub if in wide format.{p_end}
{synopt:{opt uci(varname|stub_varname)}}the upper confidence interval variable name or the name of it's stub if in wide format.{p_end}
{synopt:{opt p(varname|stub_varname)}}the p-value variable name or the name of it's stub if in wide format.{p_end}
{synopt:{opt true(#|varname|stub_varname)}}the true value, or variable name or the name of it's stub if in wide format.{p_end}
{synopt:{opt ord:er(varname)}}if in wide-wide format, this will be either {it:target} or {it:method}, 
denoting that either the target stub is first or the method stub is first in the variable names.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:siman setup} takes the user’s raw simulation data (estimates data set) and puts it in the format required by {bf:siman}. 
The user’s raw data can be in either long or wide format similar to the input for {bf:{help simsum:simsum}}.  

{pstd}
The user will have an unmodified, raw simulation data set with the repetitions of a simulation experiment, {opt rep(varname)}, as the only compulsory variable in the syntax.  Other variables of interest such as 
data generating mechanism ({opt dgm}), {opt target}, {opt method}, {opt estimate}, standard error ({opt se}) can be specified.

{pstd}
For the input data, there will be 4 data set formats permitted by the siman suite as detailed {help siman_setup##data:above}.

{pstd}
The user will declare their variables for use in {cmd:siman setup}.  {cmd:siman setup} will check the data, reformat it
and attach characteristics to the data set available for use across multiple sessions.  Every other {bf:siman} command 
will then read the characteristics of the data created in {cmd:siman setup}.  {cmd:siman setup} will allow multiple data generating 
mechanisms, multiple targets and multiple analysis methods.  The {bf:siman} estimates data set will be held in memory.
There will also be a auto-summary output available for the user to confirm the data set up (using  {bf:{help siman_describe:siman describe}}).  

{pstd}
{cmd:siman setup} will automatically reshape wide-target data (i.e. wide targets, wide
methods) or wide-long format data (i.e. wide targets, long methods) into long-wide
format. Therefore the two output data formats of {cmd:siman setup} are long-long (option
1) and long-wide (option 3).

{pstd}
Note that {bf:true} must be a {bf:variable} in the dataset for {bf:{help siman trellis:siman trellis}} and 
{bf:{help siman nestloop:siman nestloop}}, and should be listed in both the {bf:dgm()} and the {bf:true()}
options in {cmd:siman setup} before running these graphs.

{marker examples}{...}
{title:Examples}
{pstd}

{pstd}
For a data set containing the variables repetition (rep), dgm, 2 targets (contained in a variable called {it:estimand}, with 
labels {it:beta} and {it:gamma}) and 2 methods (with labels {it:1} and {it:2}), the estimate (est), standard error (se) and true variable, 
then {cmd:siman_setup} would be entered as follows:

{phang}{bf:Data in format 1:} siman setup, rep(rep) dgm(dgm) target(estimand) method(method) estimate(est) se(se) true(true){p_end}
{phang}{bf:Data in format 2:} siman setup, rep(rep) dgm(dgm) target(beta gamma) method(1 2) estimate(est) se(se) true(true) order(method){p_end}
{phang}{bf:Data in format 3:} siman setup, rep(rep) dgm(dgm) target(estimand) method(1 2) estimate(est) se(se) true(true){p_end}
{phang}{bf:Data in format 4:} siman setup, rep(rep) dgm(dgm) target(beta gamma) method(method) estimate(est) se(se) true(true){p_end}


{marker authors}{...}
{title:Authors}

{pstd}Ella Marley-Zagar, MRC Clinical Trials Unit at UCL{break}
Email: {browse "mailto:e.marley-zagar@ucl.ac.uk":Ella Marley-Zagar}

{pstd}Ian White, MRC Clinical Trials Unit at UCL{break}
Email: {browse "mailto:ian.white@ucl.ac.uk":Ian White}

{pstd}Tim Morris, MRC Clinical  Trials Unit at UCL, London, UK.{break} 
Email: {browse "mailto:tim.morris@ucl.ac.uk":Tim Morris}

{pstd}You can get the latest version of this and my other Stata software using 
{stata "net from http://github.com/emarleyzagar/"}


