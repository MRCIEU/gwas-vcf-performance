library('data.table')
library("dplyr")
library('scales')
library('ggplot2')
set.seed(123)

ci <- function(mu, sigma, n){
    error <- qnorm(0.975) * (sigma / sqrt(n))
    return(list(mean=mu, sd=sigma, lower=mu - error, upper=mu + error))
}

real2ci <- function(df){
    mu <- mean(df$real)
    sigma <- sd(df$real)
    n <- nrow(df)
    conf <- ci(mu, sigma, n)
    method <- unique(df$method)
    stopifnot(length(method) == 1)
    conf$method <- method
    return(conf)
}

get_chrpos_dat <- function(analysis){
    ### chrpos ###
    chrpos.query.uncompressed.text.awk.time <- fread(paste0(analysis, "/chrpos.query.uncompressed.text.awk.time.txt"))
    chrpos.query.uncompressed.text.grep.time <- fread(paste0(analysis, "/chrpos.query.uncompressed.text.grep.time.txt"))
    chrpos.query.compressed.text.awk.time <- fread(paste0(analysis, "/chrpos.query.compressed.text.awk.time.txt"))
    chrpos.query.compressed.text.grep.time <- fread(paste0(analysis, "/chrpos.query.compressed.text.grep.time.txt"))
    chrpos.query.uncompressed.vcf.awk.time <- fread(paste0(analysis, "/chrpos.query.uncompressed.vcf.awk.time.txt"))
    chrpos.query.uncompressed.vcf.grep.time <- fread(paste0(analysis, "/chrpos.query.uncompressed.vcf.grep.time.txt"))
    chrpos.query.compressed.vcf.awk.time <- fread(paste0(analysis, "/chrpos.query.compressed.vcf.awk.time.txt"))
    chrpos.query.compressed.vcf.grep.time <- fread(paste0(analysis, "/chrpos.query.compressed.vcf.grep.time.txt"))
    chrpos.query.compressed.vcf.bcftools.time <- fread(paste0(analysis, "/chrpos.query.compressed.vcf.bcftools.time.txt"))

    # add method
    chrpos.query.uncompressed.text.awk.time$method <- "awk - uncompressed text"
    chrpos.query.uncompressed.text.grep.time$method <- "grep - uncompressed text"
    chrpos.query.compressed.text.awk.time$method <- "awk - compressed text"
    chrpos.query.compressed.text.grep.time$method <- "grep - compressed text"
    chrpos.query.uncompressed.vcf.awk.time$method <- "awk - uncompressed vcf"
    chrpos.query.uncompressed.vcf.grep.time$method <- "grep - uncompressed vcf"
    chrpos.query.compressed.vcf.awk.time$method <- "awk - compressed vcf"
    chrpos.query.compressed.vcf.grep.time$method <- "grep - compressed vcf"
    chrpos.query.compressed.vcf.bcftools.time$method <- "bcftools - compressed vcf"

    # calc mean, sd, ci
    chrpos.all <- data.frame()
    chrpos.all <- rbind(chrpos.all, real2ci(chrpos.query.uncompressed.text.awk.time), stringsAsFactors=F)
    chrpos.all <- rbind(chrpos.all, real2ci(chrpos.query.uncompressed.text.grep.time), stringsAsFactors=F)
    chrpos.all <- rbind(chrpos.all, real2ci(chrpos.query.compressed.text.awk.time), stringsAsFactors=F)
    chrpos.all <- rbind(chrpos.all, real2ci(chrpos.query.compressed.text.grep.time), stringsAsFactors=F)
    chrpos.all <- rbind(chrpos.all, real2ci(chrpos.query.uncompressed.vcf.awk.time), stringsAsFactors=F)
    chrpos.all <- rbind(chrpos.all, real2ci(chrpos.query.uncompressed.vcf.grep.time), stringsAsFactors=F)
    chrpos.all <- rbind(chrpos.all, real2ci(chrpos.query.compressed.vcf.awk.time), stringsAsFactors=F)
    chrpos.all <- rbind(chrpos.all, real2ci(chrpos.query.compressed.vcf.grep.time), stringsAsFactors=F)
    chrpos.all <- rbind(chrpos.all, real2ci(chrpos.query.compressed.vcf.bcftools.time), stringsAsFactors=F)

    # add test & analysis
    chrpos.all$test <- "Base position"
    chrpos.all$analysis <- analysis

    return(chrpos.all)
}

get_intervals_dat <- function(analysis){
    ### Intervals ###
    intervals.query.uncompressed.text.awk.time <- fread(paste0(analysis, "/intervals.query.uncompressed.text.awk.time.txt"))
    intervals.query.compressed.text.awk.time <- fread(paste0(analysis, "/intervals.query.compressed.text.awk.time.txt"))
    intervals.query.uncompressed.vcf.awk.time <- fread(paste0(analysis, "/intervals.query.uncompressed.vcf.awk.time.txt"))
    intervals.query.compressed.vcf.awk.time <- fread(paste0(analysis, "/intervals.query.compressed.vcf.awk.time.txt"))
    intervals.query.compressed.vcf.bcftools.time <- fread(paste0(analysis, "/intervals.query.compressed.vcf.bcftools.time.txt"))

    # add methods
    intervals.query.uncompressed.text.awk.time$method <- "awk - uncompressed text"
    intervals.query.compressed.text.awk.time$method <- "awk - compressed text"
    intervals.query.uncompressed.vcf.awk.time$method <- "awk - uncompressed vcf"
    intervals.query.compressed.vcf.awk.time$method <- "awk - compressed vcf"
    intervals.query.compressed.vcf.bcftools.time$method <- "bcftools - compressed vcf"

    # calc mean, sd, ci
    intervals.all <- data.frame()
    intervals.all <- rbind(intervals.all, real2ci(intervals.query.uncompressed.text.awk.time), stringsAsFactors=F)
    intervals.all <- rbind(intervals.all, real2ci(intervals.query.compressed.text.awk.time), stringsAsFactors=F)
    intervals.all <- rbind(intervals.all, real2ci(intervals.query.uncompressed.vcf.awk.time), stringsAsFactors=F)
    intervals.all <- rbind(intervals.all, real2ci(intervals.query.compressed.vcf.awk.time), stringsAsFactors=F)
    intervals.all <- rbind(intervals.all, real2ci(intervals.query.compressed.vcf.bcftools.time), stringsAsFactors=F)

    # add test & analysis
    intervals.all$test <- "1Mb interval"
    intervals.all$analysis <- analysis
    
    return(intervals.all)
}

get_pval_dat <- function(analysis){
    ### P value ###
    pval.query.uncompressed.text.awk.time <- fread(paste0(analysis, "/pval.query.uncompressed.text.awk.time.txt"))
    pval.query.compressed.text.awk.time <- fread(paste0(analysis, "/pval.query.compressed.text.awk.time.txt"))
    pval.query.uncompressed.vcf.awk.time <- fread(paste0(analysis, "/pval.query.uncompressed.vcf.awk.time.txt"))
    pval.query.compressed.vcf.awk.time <- fread(paste0(analysis, "/pval.query.compressed.vcf.awk.time.txt"))
    pval.query.compressed.vcf.bcftools.time <- fread(paste0(analysis, "/pval.query.compressed.vcf.bcftools.time.txt"))
    pval.query.compressed.bcf.bcftools.time <- fread(paste0(analysis, "/pval.query.compressed.bcf.bcftools.time.txt"))

    # add methods
    pval.query.uncompressed.text.awk.time$method <- "awk - uncompressed text"
    pval.query.compressed.text.awk.time$method <- "awk - compressed text"
    pval.query.uncompressed.vcf.awk.time$method <- "awk - uncompressed vcf"
    pval.query.compressed.vcf.awk.time$method <- "awk - compressed vcf"
    pval.query.compressed.vcf.bcftools.time$method <- "bcftools - compressed vcf"
    pval.query.compressed.bcf.bcftools.time$method <- "bcftools - compressed bcf"

    # calc mean, sd, ci
    pval.all <- data.frame()
    pval.all <- rbind(pval.all, real2ci(pval.query.uncompressed.text.awk.time), stringsAsFactors=F)
    pval.all <- rbind(pval.all, real2ci(pval.query.compressed.text.awk.time), stringsAsFactors=F)
    pval.all <- rbind(pval.all, real2ci(pval.query.uncompressed.vcf.awk.time), stringsAsFactors=F)
    pval.all <- rbind(pval.all, real2ci(pval.query.compressed.vcf.awk.time), stringsAsFactors=F)
    pval.all <- rbind(pval.all, real2ci(pval.query.compressed.vcf.bcftools.time), stringsAsFactors=F)
    pval.all <- rbind(pval.all, real2ci(pval.query.compressed.bcf.bcftools.time), stringsAsFactors=F)

    # add test & analysis
    pval.all$test <- "P value"
    pval.all$analysis <- analysis

    return(pval.all)
}

get_rsid_dat <- function(analysis){
    ### rsID ###
    rsid.query.uncompressed.text.awk.time <- fread(paste0(analysis, "/rsid.query.uncompressed.text.awk.time.txt"))
    rsid.query.uncompressed.text.grep.time <- fread(paste0(analysis, "/rsid.query.uncompressed.text.grep.time.txt"))
    rsid.query.compressed.text.awk.time <- fread(paste0(analysis, "/rsid.query.compressed.text.awk.time.txt"))
    rsid.query.compressed.text.grep.time <- fread(paste0(analysis, "/rsid.query.compressed.text.grep.time.txt"))
    rsid.query.uncompressed.vcf.awk.time <- fread(paste0(analysis, "/rsid.query.uncompressed.vcf.awk.time.txt"))
    rsid.query.uncompressed.vcf.grep.time <- fread(paste0(analysis, "/rsid.query.uncompressed.vcf.grep.time.txt"))
    rsid.query.compressed.vcf.awk.time <- fread(paste0(analysis, "/rsid.query.compressed.vcf.awk.time.txt"))
    rsid.query.compressed.vcf.grep.time <- fread(paste0(analysis, "/rsid.query.compressed.vcf.grep.time.txt"))
    rsid.query.compressed.vcf.bcftools.time <- fread(paste0(analysis, "/rsid.query.compressed.vcf.bcftools.time.txt"))
    rsid.query.compressed.vcf.rsidx.time <- fread(paste0(analysis, "/rsid.query.compressed.vcf.rsidx.time.txt"))

    # add methods
    rsid.query.uncompressed.text.awk.time$method <- "awk - uncompressed text"
    rsid.query.uncompressed.text.grep.time$method <- "grep - uncompressed text"
    rsid.query.compressed.text.awk.time$method <- "awk - compressed text"
    rsid.query.compressed.text.grep.time$method <- "grep - compressed text"
    rsid.query.uncompressed.vcf.awk.time$method <- "awk - uncompressed vcf"
    rsid.query.uncompressed.vcf.grep.time$method <- "grep - uncompressed vcf"
    rsid.query.compressed.vcf.awk.time$method <- "awk - compressed vcf"
    rsid.query.compressed.vcf.grep.time$method <- "grep - compressed vcf"
    rsid.query.compressed.vcf.bcftools.time$method <- "bcftools - compressed vcf"
    rsid.query.compressed.vcf.rsidx.time$method <- "rsidx - compressed vcf"

    # calc mean, sd, ci
    rsid.all <- data.frame()
    rsid.all <- rbind(rsid.all, real2ci(rsid.query.uncompressed.text.awk.time), stringsAsFactors=F)
    rsid.all <- rbind(rsid.all, real2ci(rsid.query.uncompressed.text.grep.time), stringsAsFactors=F)
    rsid.all <- rbind(rsid.all, real2ci(rsid.query.compressed.text.awk.time), stringsAsFactors=F)
    rsid.all <- rbind(rsid.all, real2ci(rsid.query.compressed.text.grep.time), stringsAsFactors=F)
    rsid.all <- rbind(rsid.all, real2ci(rsid.query.uncompressed.vcf.awk.time), stringsAsFactors=F)
    rsid.all <- rbind(rsid.all, real2ci(rsid.query.uncompressed.vcf.grep.time), stringsAsFactors=F)
    rsid.all <- rbind(rsid.all, real2ci(rsid.query.compressed.vcf.awk.time), stringsAsFactors=F)
    rsid.all <- rbind(rsid.all, real2ci(rsid.query.compressed.vcf.grep.time), stringsAsFactors=F)
    rsid.all <- rbind(rsid.all, real2ci(rsid.query.compressed.vcf.bcftools.time), stringsAsFactors=F)
    rsid.all <- rbind(rsid.all, real2ci(rsid.query.compressed.vcf.rsidx.time), stringsAsFactors=F)

    # add test & analysis
    rsid.all$test <- "dbSNP identifier"
    rsid.all$analysis <- analysis

    return(rsid.all)
}

### Prepare Data ###

# load results
all <- rbind(
    get_chrpos_dat("single-sample-0.5M"),
    get_chrpos_dat("single-sample-2.5M"),
    get_chrpos_dat("single-sample-10M"),
    get_chrpos_dat("multi-sample-0.5M"),
    get_chrpos_dat("multi-sample-2.5M"),
    get_chrpos_dat("multi-sample-10M"),
    get_intervals_dat("single-sample-0.5M"),
    get_intervals_dat("single-sample-2.5M"),
    get_intervals_dat("single-sample-10M"),
    get_intervals_dat("multi-sample-0.5M"),
    get_intervals_dat("multi-sample-2.5M"),
    get_intervals_dat("multi-sample-10M"),
    get_pval_dat("single-sample-0.5M"),
    get_pval_dat("single-sample-2.5M"),
    get_pval_dat("single-sample-10M"),
    get_pval_dat("multi-sample-0.5M"),
    get_pval_dat("multi-sample-2.5M"),
    get_pval_dat("multi-sample-10M"),
    get_rsid_dat("single-sample-0.5M"),
    get_rsid_dat("single-sample-2.5M"),
    get_rsid_dat("single-sample-10M"),
    get_rsid_dat("multi-sample-0.5M"),
    get_rsid_dat("multi-sample-2.5M"),
    get_rsid_dat("multi-sample-10M")
)
all$tool <- stringr::str_trim(stringr::str_split(all$method, "-", simplify=T)[,1])
all$file <- stringr::str_trim(stringr::str_split(all$method, "-", simplify=T)[,2])

# drop bcf
all <- all[which(all$file != "compressed bcf"),]

# rename types
all$File <- all$file
all$File <- gsub("^compressed text$", "Text (GZIP)", all$File)
all$File <- gsub("^uncompressed text$", "Text", all$File)
all$File <- gsub("^compressed vcf$", "VCF (GZIP)", all$File)
all$File <- gsub("^uncompressed vcf$", "VCF", all$File)

# rename analyses
all$analysis <- gsub("single-sample-0.5M", "Single GWAS (0.5M)", all$analysis)
all$analysis <- gsub("single-sample-2.5M", "Single GWAS (2.5M)", all$analysis)
all$analysis <- gsub("multi-sample-0.5M", "Multiple GWAS (0.5M)", all$analysis)
all$analysis <- gsub("multi-sample-2.5M", "Multiple GWAS (2.5M)", all$analysis)
all$analysis <- gsub("single-sample-10M", "Single GWAS (10M)", all$analysis)
all$analysis <- gsub("multi-sample-10M", "Multiple GWAS (10M)", all$analysis)

# factorise
all$test <- factor(all$test, levels=c('Base position','dbSNP identifier','1Mb interval','P value'))
all$analysis <- factor(all$analysis, levels=c("Single GWAS (0.5M)", "Multiple GWAS (0.5M)", "Single GWAS (2.5M)","Multiple GWAS (2.5M)","Single GWAS (10M)","Multiple GWAS (10M)"))
all$tool <- factor(all$tool, levels=c('awk','bcftools','grep','rsidx'))

### Plot ###

# plot
all <- all %>% 
    filter(!(test=="dbSNP identifier" & tool=="bcftools")) %>%
    filter(!(File=="VCF" & tool=="awk")) %>%
    filter(!(File=="VCF" & tool=="grep")) %>%
    filter(!(File=="VCF (GZIP)" & tool=="awk")) %>%
    filter(!(File=="VCF (GZIP)" & tool=="grep"))

p <- ggplot(all, aes(x=tool, y=mean, ymin=lower, ymax=upper, fill=File)) +
    geom_col(width = 0.8, position = position_dodge2(width = 0.8, preserve = "single")) +
    geom_errorbar(width = 0.08, position = position_dodge(0.8)) +
    facet_wrap(~ test + analysis, scale="free_y", ncol=6) +
    scale_y_continuous(breaks=pretty_breaks(n=5)) +
    theme_light() +
    theme(text = element_text(size=12)) +
    scale_fill_brewer(palette = "Dark2") +
    ggtitle("Query performance of GWAS-VCF and unindexed TSV using a range of common operations") +
    xlab("Method") +
    ylab("Mean runtime (seconds)") +
    theme(axis.text.x=element_text(angle=90, hjust=0.5, vjust=1))

# save
ggsave("plot.pdf", p, height=8, width=12)

#facetwrap
#facet_grid(test~analysis, scales="free", space = "free_x") +
