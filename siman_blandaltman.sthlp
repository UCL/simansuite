{smcl}
{* *! version 1.2 03mar2022}{...}
{vieweralsosee "Main siman help page" "siman"}{...}
{vieweralsosee "labelsof (if installed)" "labelsof"}{...}
{viewerjumpto "Syntax" "siman_blandaltman##syntax"}{...}
{viewerjumpto "Description" "siman_blandaltman##description"}{...}
{viewerjumpto "Examples" "siman_blandaltman##examples"}{...}
{viewerjumpto "Authors" "siman_blandaltman##authors"}{...}
{viewerjumpto "See also" "siman_blandaltman##seealso"}{...}
{title:Title}

{phang}
{bf:siman blandaltman} {hline 2} Bland-Altman plot comparing methods of estimates or standard error data.


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:siman blandaltman} {ifin}
[{cmd:,}
{it:options}]

{pstd}If no variables are specified, then the blandaltman graph will be drawn for {it:estimates} only.  Alternatively the user can select {it:se} or {it:estimate se}.

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}

{pstd}
{p_end}
{synopt:{opt if/in}}  The user can specify {it:if} and {it:in} within the siman blandaltman syntax. If they do not, but have already specified 
an {it:if/in} during {help siman_setup:siman setup}, then the {it:if/in} from {help siman_setup:siman setup} will be used.
The {it:if} option will only apply to {bf:dgm}, {bf:target} and {bf:method}.  The {it:if} option is not allowed to be used on 
{bf:repetition} and an error message will be issued if the user tries to do so.

{pstd}
{p_end}
{synopt:{opt by(string)}}  specifies the nesting of the variables, with the default being {bf:by(dgm target)}.

{syntab:Graph options}
{pstd}
{p_end}

{pstd}{it:For the siman blandaltman graph user-inputted options, most of the valid options for {help scatter:scatter} are available.}

{pstd}
{p_end}
{synopt:{opt bygr:aphoptions(string)}}  graph options for the nesting of the graphs due to the {it:by} option.

{pstd}
{p_end}
{synopt:{opt m:ethlist(string)}}  if the user would like to display the graphs for a subgroup of methods, these methods can be specified in {bf: methlist()}.  For example, in a dataset with methods A, B and C, if the user would like to compare 
methods A and C, they would enter {bf: methlist(A C)}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:siman blandaltman} draws a Bland-Altman plot comparing estimates and/or standard error data from different methods.  If there are more than 2 methods in the data set, for example methods A B and C, then the first method will be taken 
as the reference, and the {bf:siman blandaltman} plots will be created for method B - method A and method C - method A.  Alternatively, pairs of methods can be specified for comparison using {bf: methlist()}.

{pstd}
As the Bland-Altman plots are drawn per method comparison set, the {bf: by()} variable can be used to stratify further {bf: by(dgm)} or {bf: by(target)}.  The default is {bf: by(dgm target)}.

{pstd}
The {bf:labelsof} package (by Ben Jann) is required by {bf:siman blandaltman}, which can be installed by clicking: {stata ssc install labelsof}

{pstd}
Please note that {help siman_setup:siman setup} needs to be run first before {bf:siman blandaltman}.

{marker examples}{...}
{title:Examples}

{pstd}To display the Bland-Altman graphs by target:

{pstd}siman blandaltman, by(target)

{pstd}For a dataset containing methods A, B, C and D, to display the Bland-Altman graphs only for method C compared to method A:

{pstd}siman blandaltman, methlist(A C)  

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

{marker seealso}{...}
{title:See Also}

{pstd}{help labelsof} (if installed)

{pstd}{helpb siman: Return to main help page for siman}

