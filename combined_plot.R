library('ggplot2')
library('data.table')

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

### chrpos ###
chrpos.query.uncompressed.text.awk.time <- fread("chrpos.query.uncompressed.text.awk.time.txt")
chrpos.query.uncompressed.text.grep.time <- fread("chrpos.query.uncompressed.text.grep.time.txt")
chrpos.query.compressed.text.awk.time <- fread("chrpos.query.compressed.text.awk.time.txt")
chrpos.query.compressed.text.grep.time <- fread("chrpos.query.compressed.text.grep.time.txt")
chrpos.query.uncompressed.vcf.awk.time <- fread("chrpos.query.uncompressed.vcf.awk.time.txt")
chrpos.query.uncompressed.vcf.grep.time <- fread("chrpos.query.uncompressed.vcf.grep.time.txt")
chrpos.query.compressed.vcf.awk.time <- fread("chrpos.query.compressed.vcf.awk.time.txt")
chrpos.query.compressed.vcf.grep.time <- fread("chrpos.query.compressed.vcf.grep.time.txt")
chrpos.query.compressed.vcf.bcftools.time <- fread("chrpos.query.compressed.vcf.bcftools.time.txt")

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

# add test
chrpos.all$test <- "Base position"

### Intervals ###
intervals.query.uncompressed.text.awk.time <- fread("intervals.query.uncompressed.text.awk.time.txt")
intervals.query.compressed.text.awk.time <- fread("intervals.query.compressed.text.awk.time.txt")
intervals.query.uncompressed.vcf.awk.time <- fread("intervals.query.uncompressed.vcf.awk.time.txt")
intervals.query.compressed.vcf.awk.time <- fread("intervals.query.compressed.vcf.awk.time.txt")
intervals.query.compressed.vcf.bcftools.time <- fread("intervals.query.compressed.vcf.bcftools.time.txt")

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

# add test
interval.all$test <- "1Mb interval"

### P value ###
pval.query.uncompressed.text.awk.time <- fread("pval.query.uncompressed.text.awk.time.txt")
pval.query.compressed.text.awk.time <- fread("pval.query.compressed.text.awk.time.txt")
pval.query.uncompressed.vcf.awk.time <- fread("pval.query.uncompressed.vcf.awk.time.txt")
pval.query.compressed.vcf.awk.time <- fread("pval.query.compressed.vcf.awk.time.txt")
pval.query.compressed.vcf.bcftools.time <- fread("pval.query.compressed.vcf.bcftools.time.txt")
pval.query.compressed.bcf.bcftools.time <- fread("pval.query.compressed.bcf.bcftools.time.txt")

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

# add test
pval.all$test <- "P value"

### rsID ###
rsid.query.uncompressed.text.awk.time <- fread("rsid.query.uncompressed.text.awk.time.txt")
rsid.query.uncompressed.text.grep.time <- fread("rsid.query.uncompressed.text.grep.time.txt")
rsid.query.compressed.text.awk.time <- fread("rsid.query.compressed.text.awk.time.txt")
rsid.query.compressed.text.grep.time <- fread("rsid.query.compressed.text.grep.time.txt")
rsid.query.uncompressed.vcf.awk.time <- fread("rsid.query.uncompressed.vcf.awk.time.txt")
rsid.query.uncompressed.vcf.grep.time <- fread("rsid.query.uncompressed.vcf.grep.time.txt")
rsid.query.compressed.vcf.awk.time <- fread("rsid.query.compressed.vcf.awk.time.txt")
rsid.query.compressed.vcf.grep.time <- fread("rsid.query.compressed.vcf.grep.time.txt")
rsid.query.compressed.vcf.bcftools.time <- fread("rsid.query.compressed.vcf.bcftools.time.txt")
rsid.query.compressed.vcf.rsidx.time <- fread("rsid.query.compressed.vcf.rsidx.time.txt")

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

# add test
rsid.all$test <- "dbSNP identifier"

### Plot ###

# merge dfs
all <- rbind(chrpos.all, rsid.all, intervals.all, pval.all)

# bar plot with CIs
p <- ggplot(all, aes(x=method, y=mean, fill=test)) +
    geom_bar() +
    geom_errorbar(aes(ymin=lower, ymax=upper))