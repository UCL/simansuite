{smcl}
{* *! version 1.2 20dec2021}{...}
{vieweralsosee "Main siman help page" "siman"}{...}
{vieweralsosee "labelsof (if installed)" "labelsof"}{...}
{viewerjumpto "Syntax" "siman_swarm##syntax"}{...}
{viewerjumpto "Description" "siman_swarm##description"}{...}
{viewerjumpto "Examples" "siman_swarm##examples"}{...}
{viewerjumpto "Authors" "siman_swarm##authors"}{...}
{title:Title}

{phang}
{bf:siman swarm} {hline 2} Swarm plot of estimates data.


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:siman swarm} {ifin}
[{cmd:,}
{it:options}]

{pstd}If no estimates data variables are specified, then the swarm graph will be drawn for {it:estimate} only.

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}

{pstd}
{p_end}
{synopt:{opt if/in}}  The user can specify {it:if} and {it:in} within the siman swarm syntax. If they do not, but have already specified 
an {it:if/in} during {help siman_setup:siman setup}, then the {it:if/in} from {help siman_setup:siman setup} will be used.
The {it:if} option will only apply to {bf:dgm}, {bf:target} and {bf:method}.  The {it:if} option is not allowed to be used on 
{bf:repetition} and an error message will be issued if the user tries to do so.

{pstd}
{p_end}
{synopt:{opt by(string)}}  specifies the nesting of the variables, with the default being {bf:by(dgm target method)}

{syntab:Graph options}
{pstd}
{p_end}

{pstd}{it:For the siman swarm graph user-inputted options, most of the valid options for {help scatter:scatter} are available.}

{pstd}
{p_end}
{synopt:{opt meanoff}}  to turn off displaying the mean on the swarm graphs

{pstd}
{p_end}
{synopt:{opt meangr:aphoptions(string)}}  graph options for the mean

{pstd}
{p_end}
{synopt:{opt bygr:aphoptions(string)}}  graph options for the nesting of the graphs due to the {it:by} option

{pstd}
{p_end}
{synopt:{opt graphop:tions(string)}}  graph options for the overall graphical display


{marker description}{...}
{title:Description}

{pstd}
{cmd:siman swarm} draws a swarm plot of the estimates data variables, the results of which are from analysing multiple simulated data sets with data relating to different statistics (e.g. point estimate, p-value) for each simulated data set.

{pstd}
Please note that {help siman_setup:siman setup} needs to be run first before siman swarm.  If the data is not already in long-long format then it will be reshaped to this format to create the graphs 
(see {help siman_reshape:siman reshape} for further details on data 
format types and the reshape command).

{pstd}
{cmd:siman swarm} requires a {bf:method} variable/values in the estimates dataset defined in the {help siman_setup:siman setup} syntax by {bf:method()}. 
 
{pstd}
{cmd:siman swarm} requires at least 2 methods to compare.

{pstd}
The {cmd:labelsof} package (by Ben Jann) is required by siman swarm, which can be installed by clicking: {stata ssc install labelsof}


{marker examples}{...}
{title:Examples}

{pstd}siman swarm, meanoff scheme(s1color) bygraphoptions(title("main-title")) graphoptions(ytitle("test y-title"))

{pstd}siman swarm, scheme(economist) bygraphoptions(title("main-title")) graphoptions(ytitle("test y-title") xtitle("test x-title"))

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


{pstd}{helpb siman: Return to main help page for siman}


{title:See Also}


{pstd}{help labelsof} (if installed)

