#' Environment for Gene Expression Signature Searching Combined with 
#' Functional Enrichment Analysis
#'
#' @name signatureSearch-package
#' @aliases signatureSearch-package signatureSearch gess fea 
#' @docType package
#' @useDynLib signatureSearch
#' @import Rcpp
#' @description 
#' Welcome to the signatureSearch package! This package implements algorithms 
#' and data structures for performing gene expression signature (GES) searches, 
#' and subsequently interpreting the results functionally with specialized 
#' enrichment methods. These utilities are useful for studying the effects of 
#' genetic, chemical and environmental perturbations on biological systems. 
#' Specifically, in drug discovery they can be used for identifying novel modes 
#' of action (MOA) of bioactive compounds from reference databases such as 
#' LINCS containing the genome-wide GESs from tens of thousands of drug and 
#' genetic perturbations (Subramanian et al. 2017)
#' 
#' A typical GES search (GESS) workflow can be divided into two major steps.
#' First, GESS methods are used to identify perturbagens such as drugs that 
#' induce GESs similar to a query GES of interest. The queries can be drug-, 
#' disease- or phenotype-related GESs. Since the MOAs of most drugs in the 
#' corresponding reference databases are known, the resulting associations are 
#' useful to gain insights into pharmacological and/or disease mechanisms, and 
#' to develop novel drug repurposing approaches.
#' 
#' Second, specialized functional enrichment analysis (FEA) methods using 
#' annotations systems, such as Gene Ontologies (GO), pathways or Disease 
#' Ontologies (DO), have been developed and implemented in this package to 
#' efficiently interpret GESS results. The latter are usually composed of lists 
#' of perturbagens (e.g. drugs) ranked by the similarity metric of the 
#' corresponding GESS method.
#' 
#' Finally, network resconstruction functionalities are integrated for 
#' visualizing the final results, e.g. in form of drug-target networks.
#' 
#' @section Terminology:
#' The term Gene Expression Signatures (GESs) can refer to at least four 
#' different situations of pre-processed gene expression data: (1) normalized 
#' gene expression intensity values (or counts for RNA-Seq); (2) log2 fold 
#' changes (LFC), z-scores or p-values obtained from analysis routines of 
#' differentially expressed genes (DEGs); (3) rank transformed versions of the 
#' expression values obtained under (1) and (2); and (4) gene identifier sets 
#' extracted from the top and lowest ranks under (3), such as n top up/down 
#' regulated DEGs.
#' 
#' @details 
#' The GESS methods include \code{CMAP}, \code{LINCS}, \code{gCMAP}, 
#' \code{Fisher} and \code{Cor}. For detailed
#' description, please see help files of each method. Most methods 
#' can be easily paralleled for multiple query signatures.
#' 
#' GESS results are lists of perturbagens (here drugs) ranked by their 
#' signature similarity to a query signature of interest. Interpreting these 
#' search results with respect to the cellular networks and pathways affected 
#' by the top ranking drugs is difficult. To overcome this challenge, the 
#' knowledge of the target proteins of the top ranking drugs can be used to 
#' perform functional enrichment analysis (FEA) based on community annotation 
#' systems, such as Gene Ontologies (GO), pathways (e.g. KEGG, Reactome), drug 
#' MOAs or Pfam domains. For this, the ranked drug sets are converted into 
#' target gene/protein sets to perform Target Set Enrichment Analysis (TSEA) 
#' based on a chosen annotation system. Alternatively, the functional 
#' annotation categories of the targets can be assigned to the drugs directly 
#' to perform Drug Set Enrichment Analysis (DSEA). Although TSEA and DSEA are 
#' related, their enrichment results can be distinct. This is mainly due to 
#' duplicated targets present in the test sets of the TSEA methods, whereas 
#' the drugs in the test sets of DSEA are usually unique. Additional reasons 
#' include differences in the universe sizes used for TSEA and DSEA.
#' 
#' Importantly, the duplications in the test sets of the TSEA are due to the 
#' fact that many drugs share the same target proteins. Standard enrichment 
#' methods would eliminate these duplications since they assume uniqueness 
#' in the test sets. Removing duplications in TSEA would be inappropriate 
#' since it would erase one of the most important pieces of information of 
#' this approach. To solve this problem, we have developed and implemented in 
#' this package weighting methods (\code{dup_hyperG}, \code{mGSEA} and 
#' \code{meanAbs}) for duplicated targets, where the weighting 
#' is proportional to the frequency of the targets in the test set.
#' 
#' Instead of translating ranked lists of drugs into target sets, as for TSEA, 
#' the functional annotation categories of the targets can be assigned to the 
#' drugs directly to perform DSEA instead. Since the drug lists from GESS 
#' results are usually unique, this strategy overcomes the duplication problem 
#' of the TSEA approach. This way classical enrichment methods, such as GSEA or 
#' tests based on the hypergeometric distribution, can be readily applied 
#' without major modifications to the underlying statistical methods. As 
#' explained above, TSEA and DSEA performed with the same enrichment statistics 
#' are not expected to generate identical results. Rather they often complement 
#' each other's strengths and weaknesses.
#' 
#' To perform TSEA and DSEA, drug-target annotations are essential. They can be
#' obtained from several sources, including DrugBank, ChEMBL, STITCH, and the 
#' Touchstone dataset from the LINCS project (https://clue.io/). Most 
#' drug-target annotations provide UniProt identifiers for the target proteins. 
#' They can be mapped, if necessary via their encoding genes, to the chosen 
#' functional annotation categories, such as GO or KEGG. To minimize bias in 
#' TSEA or DSEA, often caused by promiscuous binders, it can be beneficial to 
#' remove drugs or targets that bind to large numbers of distinct proteins or 
#' drugs, respectively.
#' 
#' Note, in this vignette, the target genes of drugs always refer to
#' the target protein-encoding genes. The protein ids (such as UniProt ids) are 
#' mapped to their encoding gene ids (such as gene Symbols) via existing id 
#' mapping resources, such as `org.Hs.eg.db` R/Bioconductor annotation package. 
#' 
#' @seealso 
#' Methods for GESS:
#'   \itemize{
#'     \item \code{\link{gess_cmap}}, \code{\link{gess_lincs}}, 
#'           \code{\link{gess_gcmap}} \code{\link{gess_fisher}}, 
#'           \code{\link{gess_cor}}
#'   }
#'    
#' Methods for FEA:
#'   \itemize{
#'      \item TSEA methods:    
#'          \code{\link{tsea_dup_hyperG}}, \code{\link{tsea_mGSEA}},
#'          \code{\link{tsea_mabs}}
#'      
#'      \item DSEA methods:
#'      \code{\link{dsea_hyperG}}, \code{\link{dsea_GSEA}}
#'   }
#' @author
#' \itemize{
#'   \item Yuzhu Duan (yduan004@ucr.edu)
#'   \item Thomas Girke (thomas.girke@ucr.edu)
#' } 
#' 
#' @references 
#' Subramanian, Aravind, Rajiv Narayan, Steven M Corsello, David D Peck, Ted E 
#' Natoli, Xiaodong Lu, Joshua Gould, et al. 2017. A Next Generation 
#' Connectivity Map: L1000 Platform and the First 1,000,000 Profiles. Cell 171 
#' (6): 1437-1452.e17. http://dx.doi.org/10.1016/j.cell.2017.10.049
#' 
#' Lamb, Justin, Emily D Crawford, David Peck, Joshua W Modell, Irene C Blat, 
#' Matthew J Wrobel, Jim Lerner, et al. 2006. The Connectivity Map: Using 
#' Gene-Expression Signatures to Connect Small Molecules, Genes, and Disease. 
#' Science 313 (5795): 1929-35. http://dx.doi.org/10.1126/science.1132939
#' 
#' Sandmann, Thomas, Sarah K Kummerfeld, Robert Gentleman, and Richard Bourgon. 
#' 2014. gCMAP: User-Friendly Connectivity Mapping with R. Bioinformatics 30 
#' (1): 127-28. http://dx.doi.org/10.1093/bioinformatics/btt592
#' 
#' Subramanian, Aravind, Pablo Tamayo, Vamsi K Mootha, Sayan Mukherjee, 
#' Benjamin L Ebert, Michael A Gillette, Amanda Paulovich, et al. 2005. 
#' Gene Set Enrichment Analysis: A Knowledge-Based Approach for Interpreting 
#' Genome-Wide Expression Profiles. Proc. Natl. Acad. Sci. U. S. A. 102 (43): 
#' 15545-50. http://dx.doi.org/10.1073/pnas.0506580102

NULL


#' Drug names used in examples
#' 
#' A character vector containing the names of the top 10 drugs in the GESS result 
#' from the gess_lincs method used in the vignette of signatureSearch.
#'
#' @name drugs
#' @aliases drugs
#' @docType data
#' @examples
#' # Load drugs object
#' data(drugs)
#' drugs
#' @keywords datasets
"drugs"

#' Target Sample Data Set
#' 
#' A named numeric vector with Gene Symbols as names. It is the first 1000
#' elements from the 'targets' slot of the 'mgsea_res' result object introduced in
#' the vignette of this package. The scores represent the weights of the target
#' genes/proteins in the target set of the selected top 10 drugs.
#'
#' @name targetList
#' @aliases targetList
#' @docType data
#' @examples 
#' # Load object
#' data(targetList)
#' targetList
#' @keywords datasets
"targetList"