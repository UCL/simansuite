{smcl}
{* *! version 0.4 13jan2022}{...}
{vieweralsosee "Main siman help page" "siman"}{...}
{viewerjumpto "Syntax" "siman_table##syntax"}{...}
{viewerjumpto "Description" "siman_table##description"}{...}
{viewerjumpto "Authors" "siman_table##authors"}{...}
{title:Title}

{phang}
{bf:siman table} {hline 2} Describes the performance measures data created by {bf:{help siman_analyse:siman analyse}}


{marker syntax}{...}
{title:Syntax}

{phang}
{cmdab:siman table} [{it:performancemeasures}] [if], [column({it:varname})]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}

{pstd}
{p_end}
{synopt:{opt if}} can be applied to {bf:dgm}, {bf:target} and {bf:method}.  If not specified then the {it:if} condition from {bf:{help siman_analyse:siman analyse}} will be used.

{pstd}
{p_end}

{marker perfmeas}{...}
{syntab:Performance measure options:}

{pstd}
See {help siman_analyse##perfmeas:performance measures} as per {help siman_analyse:siman analyse} and {help simsum:simsum}.
{p_end}

{syntab:Formatting}

{synopt:{opt c:olumn(varname)}} can be used to move factors to columns.{p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}
{pstd}
{p_end}

{pstd}
{cmd:siman table} uses the inbuilt Stata program {help tabdisp:tabdisp} to provide a summary of the performance measures created by {bf:{help siman_analyse:siman analyse}}.
The output table lists the estimand(s) split by performance measure(s) and methods.

{pstd}
{cmd:siman table} is called automatically by {bf:{help siman_analyse:siman analyse}}, 
but can also be called on its own once the performance measures data 
has been created by the {bf:siman} suite.


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


