library('ggplot2')
library('data.table')

ci <- function(mu, sigma, n){
    error <- qt(0.975, df = n-1 ) * sigma / sqrt(n)
    return(list(mean=mu, sd=sigma, lower=mu - error, upper=mu + error))
}

### chrpos ###

# read in query return line counts

## text
chrpos.query.uncompressed.text.awk.counts <- fread("chrpos.query.uncompressed.text.awk.counts.txt")
chrpos.query.uncompressed.text.grep.counts <- fread("chrpos.query.uncompressed.text.grep.counts.txt")
chrpos.query.compressed.text.awk.counts <- fread("chrpos.query.compressed.text.awk.counts.txt")
chrpos.query.compressed.text.grep.counts <- fread("chrpos.query.compressed.text.grep.counts.txt")
## vcf
chrpos.query.uncompressed.vcf.awk.counts <- fread("chrpos.query.uncompressed.vcf.awk.counts.txt")
chrpos.query.uncompressed.vcf.grep.counts <- fread("chrpos.query.uncompressed.vcf.grep.counts.txt")
chrpos.query.compressed.vcf.awk.counts <- fread("chrpos.query.compressed.vcf.awk.counts.txt")
chrpos.query.compressed.vcf.grep.counts <- fread("chrpos.query.compressed.vcf.grep.counts.txt")
chrpos.query.compressed.vcf.bcftools.counts <- fread("chrpos.query.compressed.vcf.bcftools.counts.txt")

# check line counts equal to n_sim
stopifnot(sum(chrpos.query.uncompressed.text.awk.counts$n == 1) == params$n_sim)
stopifnot(sum(chrpos.query.uncompressed.text.grep.counts$n == 1) == params$n_sim)
stopifnot(sum(chrpos.query.compressed.text.awk.counts$n == 1) == params$n_sim)
stopifnot(sum(chrpos.query.compressed.text.grep.counts$n == 1) == params$n_sim)
stopifnot(sum(chrpos.query.uncompressed.vcf.awk.counts$n == 1) == params$n_sim)
stopifnot(sum(chrpos.query.uncompressed.vcf.grep.counts$n == 1) == params$n_sim)
stopifnot(sum(chrpos.query.compressed.vcf.awk.counts$n == 1) == params$n_sim)
stopifnot(sum(chrpos.query.compressed.vcf.grep.counts$n == 1) == params$n_sim)
stopifnot(sum(chrpos.query.compressed.vcf.bcftools.counts$n == 1) == params$n_sim)

# read in query time

## text
chrpos.query.uncompressed.text.awk.time <- fread("chrpos.query.uncompressed.text.awk.time.txt")
chrpos.query.uncompressed.text.grep.time <- fread("chrpos.query.uncompressed.text.grep.time.txt")
chrpos.query.compressed.text.awk.time <- fread("chrpos.query.compressed.text.awk.time.txt")
chrpos.query.compressed.text.grep.time <- fread("chrpos.query.compressed.text.grep.time.txt")
## vcf
chrpos.query.uncompressed.vcf.awk.time <- fread("chrpos.query.uncompressed.vcf.awk.time.txt")
chrpos.query.uncompressed.vcf.grep.time <- fread("chrpos.query.uncompressed.vcf.grep.time.txt")
chrpos.query.compressed.vcf.awk.time <- fread("chrpos.query.compressed.vcf.awk.time.txt")
chrpos.query.compressed.vcf.grep.time <- fread("chrpos.query.compressed.vcf.grep.time.txt")
chrpos.query.compressed.vcf.bcftools.time <- fread("chrpos.query.compressed.vcf.bcftools.time.txt")

# add methods
chrpos.query.uncompressed.text.awk.time$method <- "awk - uncompressed text"
print(ci(mean(chrpos.query.uncompressed.text.awk.time$real), sd(chrpos.query.uncompressed.text.awk.time$real), nrow(chrpos.query.uncompressed.text.awk.time)))
chrpos.query.uncompressed.text.grep.time$method <- "grep - uncompressed text"
print(ci(mean(chrpos.query.uncompressed.text.grep.time$real), sd(chrpos.query.uncompressed.text.grep.time$real), nrow(chrpos.query.uncompressed.text.grep.time)))
chrpos.query.compressed.text.awk.time$method <- "awk - compressed text"
print(ci(mean(chrpos.query.compressed.text.awk.time$real), sd(chrpos.query.compressed.text.awk.time$real), nrow(chrpos.query.compressed.text.awk.time)))
chrpos.query.compressed.text.grep.time$method <- "grep - compressed text"
print(ci(mean(chrpos.query.compressed.text.grep.time$real), sd(chrpos.query.compressed.text.grep.time$real), nrow(chrpos.query.compressed.text.grep.time)))

chrpos.query.uncompressed.vcf.awk.time$method <- "awk - uncompressed vcf"
print(ci(mean(chrpos.query.uncompressed.vcf.awk.time$real), sd(chrpos.query.uncompressed.vcf.awk.time$real), nrow(chrpos.query.uncompressed.vcf.awk.time)))
chrpos.query.uncompressed.vcf.grep.time$method <- "grep - uncompressed vcf"
print(ci(mean(chrpos.query.uncompressed.vcf.grep.time$real), sd(chrpos.query.uncompressed.vcf.grep.time$real), nrow(chrpos.query.uncompressed.vcf.grep.time)))
chrpos.query.compressed.vcf.awk.time$method <- "awk - compressed vcf"
print(ci(mean(chrpos.query.compressed.vcf.awk.time$real), sd(chrpos.query.compressed.vcf.awk.time$real), nrow(chrpos.query.compressed.vcf.awk.time)))
chrpos.query.compressed.vcf.grep.time$method <- "grep - compressed vcf"
print(ci(mean(chrpos.query.compressed.vcf.grep.time$real), sd(chrpos.query.compressed.vcf.grep.time$real), nrow(chrpos.query.compressed.vcf.grep.time)))
chrpos.query.compressed.vcf.bcftools.time$method <- "bcftools - compressed vcf"
print(ci(mean(chrpos.query.compressed.vcf.bcftools.time$real), sd(chrpos.query.compressed.vcf.bcftools.time$real), nrow(chrpos.query.compressed.vcf.bcftools.time)))

# merge
chrpos.all <- rbind(
    chrpos.query.uncompressed.text.awk.time[, c("real", "method")],
    chrpos.query.compressed.text.awk.time[, c("real", "method")],
    chrpos.query.uncompressed.text.grep.time[, c("real", "method")],
    chrpos.query.compressed.text.grep.time[, c("real", "method")],
    chrpos.query.uncompressed.vcf.awk.time[, c("real", "method")],
    chrpos.query.compressed.vcf.awk.time[, c("real", "method")],
    chrpos.query.uncompressed.vcf.grep.time[, c("real", "method")],
    chrpos.query.compressed.vcf.grep.time[, c("real", "method")],
    chrpos.query.compressed.vcf.bcftools.time[, c("real", "method")]
)
chrpos.all$method <- as.factor(chrpos.all$method)
chrpos.all$test <- "Base position"

### Interval ###

# read in query return line counts

## text
intervals.query.uncompressed.text.awk.counts <- fread("intervals.query.uncompressed.text.awk.counts.txt")
intervals.query.compressed.text.awk.counts <- fread("intervals.query.compressed.text.awk.counts.txt")
## vcf
intervals.query.uncompressed.vcf.awk.counts <- fread("intervals.query.uncompressed.vcf.awk.counts.txt")
intervals.query.compressed.vcf.awk.counts <- fread("intervals.query.compressed.vcf.awk.counts.txt")
intervals.query.compressed.vcf.bcftools.counts <- fread("intervals.query.compressed.vcf.bcftools.counts.txt")

# check line counts equal to expected_n
stopifnot(intervals.query.uncompressed.text.awk.counts$n == intervals.query.uncompressed.text.awk.counts$expected_n)
stopifnot(intervals.query.compressed.text.awk.counts$n == intervals.query.compressed.text.awk.counts$expected_n)
stopifnot(intervals.query.uncompressed.vcf.awk.counts$n == intervals.query.uncompressed.vcf.awk.counts$expected_n)
stopifnot(intervals.query.compressed.vcf.awk.counts$n == intervals.query.compressed.vcf.awk.counts$expected_n)
stopifnot(intervals.query.compressed.vcf.bcftools.counts$n == intervals.query.compressed.vcf.bcftools.counts$expected_n)

# read in query time

## text
intervals.query.uncompressed.text.awk.time <- fread("intervals.query.uncompressed.text.awk.time.txt")
intervals.query.compressed.text.awk.time <- fread("intervals.query.compressed.text.awk.time.txt")
## vcf
intervals.query.uncompressed.vcf.awk.time <- fread("intervals.query.uncompressed.vcf.awk.time.txt")
intervals.query.compressed.vcf.awk.time <- fread("intervals.query.compressed.vcf.awk.time.txt")
intervals.query.compressed.vcf.bcftools.time <- fread("intervals.query.compressed.vcf.bcftools.time.txt")

# add methods
intervals.query.uncompressed.text.awk.time$method <- "awk - uncompressed text"
print(ci(mean(intervals.query.uncompressed.text.awk.time$real), sd(intervals.query.uncompressed.text.awk.time$real), nrow(intervals.query.uncompressed.text.awk.time)))
intervals.query.compressed.text.awk.time$method <- "awk - compressed text"
print(ci(mean(intervals.query.compressed.text.awk.time$real), sd(intervals.query.compressed.text.awk.time$real), nrow(intervals.query.compressed.text.awk.time)))

intervals.query.uncompressed.vcf.awk.time$method <- "awk - uncompressed vcf"
print(ci(mean(intervals.query.uncompressed.vcf.awk.time$real), sd(intervals.query.uncompressed.vcf.awk.time$real), nrow(intervals.query.uncompressed.vcf.awk.time)))
intervals.query.compressed.vcf.awk.time$method <- "awk - compressed vcf"
print(ci(mean(intervals.query.compressed.vcf.awk.time$real), sd(intervals.query.compressed.vcf.awk.time$real), nrow(intervals.query.compressed.vcf.awk.time)))
intervals.query.compressed.vcf.bcftools.time$method <- "bcftools - compressed vcf"
print(ci(mean(intervals.query.compressed.vcf.bcftools.time$real), sd(intervals.query.compressed.vcf.bcftools.time$real), nrow(intervals.query.compressed.vcf.bcftools.time)))

# merge
interval.all <- rbind(
    intervals.query.uncompressed.text.awk.time[, c("real", "method")],
    intervals.query.compressed.text.awk.time[, c("real", "method")],
    intervals.query.uncompressed.vcf.awk.time[, c("real", "method")],
    intervals.query.compressed.vcf.awk.time[, c("real", "method")],
    intervals.query.compressed.vcf.bcftools.time[, c("real", "method")]
)
interval.all$method <- as.factor(interval.all$method)
interval.all$test <- "1Mb interval"

### P value ###

# read in query return line counts

## text
pval.query.uncompressed.text.awk.counts <- fread("pval.query.uncompressed.text.awk.counts.txt")
pval.query.compressed.text.awk.counts <- fread("pval.query.compressed.text.awk.counts.txt")
## vcf
pval.query.uncompressed.vcf.awk.counts <- fread("pval.query.uncompressed.vcf.awk.counts.txt")
pval.query.compressed.vcf.awk.counts <- fread("pval.query.compressed.vcf.awk.counts.txt")
pval.query.compressed.vcf.bcftools.counts <- fread("pval.query.compressed.vcf.bcftools.counts.txt")
pval.query.compressed.bcf.bcftools.counts <- fread("pval.query.compressed.bcf.bcftools.counts.txt")

# check line counts equal to expected_n
stopifnot(pval.query.uncompressed.text.awk.counts$n == pval.query.uncompressed.text.awk.counts$expected_n)
stopifnot(pval.query.compressed.text.awk.counts$n == pval.query.compressed.text.awk.counts$expected_n)
stopifnot(pval.query.uncompressed.vcf.awk.counts$n == pval.query.uncompressed.vcf.awk.counts$expected_n)
stopifnot(pval.query.compressed.vcf.awk.counts$n == pval.query.compressed.vcf.awk.counts$expected_n)
stopifnot(pval.query.compressed.vcf.bcftools.counts$n == pval.query.compressed.vcf.bcftools.counts$expected_n)
stopifnot(pval.query.compressed.bcf.bcftools.counts$n == pval.query.compressed.bcf.bcftools.counts$expected_n)

# read in query time

## text
pval.query.uncompressed.text.awk.time <- fread("pval.query.uncompressed.text.awk.time.txt")
pval.query.compressed.text.awk.time <- fread("pval.query.compressed.text.awk.time.txt")
## vcf
pval.query.uncompressed.vcf.awk.time <- fread("pval.query.uncompressed.vcf.awk.time.txt")
pval.query.compressed.vcf.awk.time <- fread("pval.query.compressed.vcf.awk.time.txt")
pval.query.compressed.vcf.bcftools.time <- fread("pval.query.compressed.vcf.bcftools.time.txt")
pval.query.compressed.bcf.bcftools.time <- fread("pval.query.compressed.bcf.bcftools.time.txt")

# add methods
pval.query.uncompressed.text.awk.time$method <- "awk - uncompressed text"
print(ci(mean(pval.query.uncompressed.text.awk.time$real), sd(pval.query.uncompressed.text.awk.time$real), nrow(pval.query.uncompressed.text.awk.time)))
pval.query.compressed.text.awk.time$method <- "awk - compressed text"
print(ci(mean(pval.query.compressed.text.awk.time$real), sd(pval.query.compressed.text.awk.time$real), nrow(pval.query.compressed.text.awk.time)))

pval.query.uncompressed.vcf.awk.time$method <- "awk - uncompressed vcf"
print(ci(mean(pval.query.uncompressed.vcf.awk.time$real), sd(pval.query.uncompressed.vcf.awk.time$real), nrow(pval.query.uncompressed.vcf.awk.time)))
pval.query.compressed.vcf.awk.time$method <- "awk - compressed vcf"
print(ci(mean(pval.query.compressed.vcf.awk.time$real), sd(pval.query.compressed.vcf.awk.time$real), nrow(pval.query.compressed.vcf.awk.time)))
pval.query.compressed.vcf.bcftools.time$method <- "bcftools - compressed vcf"
print(ci(mean(pval.query.compressed.vcf.bcftools.time$real), sd(pval.query.compressed.vcf.bcftools.time$real), nrow(pval.query.compressed.vcf.bcftools.time)))
pval.query.compressed.bcf.bcftools.time$method <- "bcftools - compressed bcf"
print(ci(mean(pval.query.compressed.bcf.bcftools.time$real), sd(pval.query.compressed.bcf.bcftools.time$real), nrow(pval.query.compressed.bcf.bcftools.time)))

# merge
pval.all <- rbind(
    pval.query.uncompressed.text.awk.time[, c("real", "method")],
    pval.query.compressed.text.awk.time[, c("real", "method")],
    pval.query.uncompressed.vcf.awk.time[, c("real", "method")],
    pval.query.compressed.vcf.awk.time[, c("real", "method")],
    pval.query.compressed.vcf.bcftools.time[, c("real", "method")],
    pval.query.compressed.bcf.bcftools.time[, c("real", "method")]
)
pval.all$method <- as.factor(pval.all$method)
pval.all$test <- "P value"

### rsID ###

## text
rsid.query.uncompressed.text.awk.counts <- fread("rsid.query.uncompressed.text.awk.counts.txt")
rsid.query.uncompressed.text.grep.counts <- fread("rsid.query.uncompressed.text.grep.counts.txt")
rsid.query.compressed.text.awk.counts <- fread("rsid.query.compressed.text.awk.counts.txt")
rsid.query.compressed.text.grep.counts <- fread("rsid.query.compressed.text.grep.counts.txt")
## vcf
rsid.query.uncompressed.vcf.awk.counts <- fread("rsid.query.uncompressed.vcf.awk.counts.txt")
rsid.query.uncompressed.vcf.grep.counts <- fread("rsid.query.uncompressed.vcf.grep.counts.txt")
rsid.query.compressed.vcf.awk.counts <- fread("rsid.query.compressed.vcf.awk.counts.txt")
rsid.query.compressed.vcf.grep.counts <- fread("rsid.query.compressed.vcf.grep.counts.txt")
rsid.query.compressed.vcf.bcftools.counts <- fread("rsid.query.compressed.vcf.bcftools.counts.txt")
rsid.query.compressed.vcf.rsidx.counts <- fread("rsid.query.compressed.vcf.rsidx.counts.txt")

# check line counts equal to n_sim
stopifnot(sum(rsid.query.uncompressed.vcf.awk.counts$n == 1) == params$n_sim)
stopifnot(sum(rsid.query.uncompressed.vcf.grep.counts$n == 1) == params$n_sim)
stopifnot(sum(rsid.query.compressed.vcf.awk.counts$n == 1) == params$n_sim)
stopifnot(sum(rsid.query.compressed.vcf.grep.counts$n == 1) == params$n_sim)
stopifnot(sum(rsid.query.compressed.vcf.bcftools.counts$n == 1) == params$n_sim)
stopifnot(sum(rsid.query.compressed.vcf.rsidx.counts$n == 1) == params$n_sim)

# read in query time

## text
rsid.query.uncompressed.text.awk.time <- fread("rsid.query.uncompressed.text.awk.time.txt")
rsid.query.uncompressed.text.grep.time <- fread("rsid.query.uncompressed.text.grep.time.txt")
rsid.query.compressed.text.awk.time <- fread("rsid.query.compressed.text.awk.time.txt")
rsid.query.compressed.text.grep.time <- fread("rsid.query.compressed.text.grep.time.txt")
## vcf
rsid.query.uncompressed.vcf.awk.time <- fread("rsid.query.uncompressed.vcf.awk.time.txt")
rsid.query.uncompressed.vcf.grep.time <- fread("rsid.query.uncompressed.vcf.grep.time.txt")
rsid.query.compressed.vcf.awk.time <- fread("rsid.query.compressed.vcf.awk.time.txt")
rsid.query.compressed.vcf.grep.time <- fread("rsid.query.compressed.vcf.grep.time.txt")
rsid.query.compressed.vcf.bcftools.time <- fread("rsid.query.compressed.vcf.bcftools.time.txt")
rsid.query.compressed.vcf.rsidx.time <- fread("rsid.query.compressed.vcf.rsidx.time.txt")

# add methods
rsid.query.uncompressed.text.awk.time$method <- "awk - uncompressed text"
print(ci(mean(rsid.query.uncompressed.text.awk.time$real), sd(rsid.query.uncompressed.text.awk.time$real), nrow(rsid.query.uncompressed.text.awk.time)))
rsid.query.uncompressed.text.grep.time$method <- "grep - uncompressed text"
print(ci(mean(rsid.query.uncompressed.text.grep.time$real), sd(rsid.query.uncompressed.text.grep.time$real), nrow(rsid.query.uncompressed.text.grep.time)))
rsid.query.compressed.text.awk.time$method <- "awk - compressed text"
print(ci(mean(rsid.query.compressed.text.awk.time$real), sd(rsid.query.compressed.text.awk.time$real), nrow(rsid.query.compressed.text.awk.time)))
rsid.query.compressed.text.grep.time$method <- "grep - compressed text"
print(ci(mean(rsid.query.compressed.text.grep.time$real), sd(rsid.query.compressed.text.grep.time$real), nrow(rsid.query.compressed.text.grep.time)))

rsid.query.uncompressed.vcf.awk.time$method <- "awk - uncompressed vcf"
print(ci(mean(rsid.query.uncompressed.vcf.awk.time$real), sd(rsid.query.uncompressed.vcf.awk.time$real), nrow(rsid.query.uncompressed.vcf.awk.time)))
rsid.query.uncompressed.vcf.grep.time$method <- "grep - uncompressed vcf"
print(ci(mean(rsid.query.uncompressed.vcf.grep.time$real), sd(rsid.query.uncompressed.vcf.grep.time$real), nrow(rsid.query.uncompressed.vcf.grep.time)))
rsid.query.compressed.vcf.awk.time$method <- "awk - compressed vcf"
print(ci(mean(rsid.query.compressed.vcf.awk.time$real), sd(rsid.query.compressed.vcf.awk.time$real), nrow(rsid.query.compressed.vcf.awk.time)))
rsid.query.compressed.vcf.grep.time$method <- "grep - compressed vcf"
print(ci(mean(rsid.query.compressed.vcf.grep.time$real), sd(rsid.query.compressed.vcf.grep.time$real), nrow(rsid.query.compressed.vcf.grep.time)))
rsid.query.compressed.vcf.bcftools.time$method <- "bcftools - compressed vcf"
print(ci(mean(rsid.query.compressed.vcf.bcftools.time$real), sd(rsid.query.compressed.vcf.bcftools.time$real), nrow(rsid.query.compressed.vcf.bcftools.time)))
rsid.query.compressed.vcf.rsidx.time$method <- "rsidx - compressed vcf"
print(ci(mean(rsid.query.compressed.vcf.rsidx.time$real), sd(rsid.query.compressed.vcf.rsidx.time$real), nrow(rsid.query.compressed.vcf.rsidx.time)))

# merge
rsid.all <- rbind(
    rsid.query.uncompressed.text.awk.time[, c("real", "method")],
    rsid.query.compressed.text.awk.time[, c("real", "method")],
    rsid.query.uncompressed.text.grep.time[, c("real", "method")],
    rsid.query.compressed.text.grep.time[, c("real", "method")],
    rsid.query.uncompressed.vcf.awk.time[, c("real", "method")],
    rsid.query.compressed.vcf.awk.time[, c("real", "method")],
    rsid.query.uncompressed.vcf.grep.time[, c("real", "method")],
    rsid.query.compressed.vcf.grep.time[, c("real", "method")],
    rsid.query.compressed.vcf.bcftools.time[, c("real", "method")],
    rsid.query.compressed.vcf.rsidx.time[, c("real", "method")]
)
rsid.all$method <- as.factor(rsid.all$method)
rsid.all$test <- "dbSNP identifier"

### Plot ###

# combine all tests
all <- rbind(chrpos.all, rsid.all, interval.all, pval.all)
