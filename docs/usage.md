# Usage Notes

## Regex Pattern

The script recognizes filenames matching:

```regex
^(.+)[_-][Rr]([12])\.(fastq|fq)(\.gz)?$
```

This matches:

- `Sample1_R1.fastq`
- `sample_02_R2.FASTQ`
- `SampleThree-r1.fq`
- `sample_04_R1.fastq.gz`

It deliberately rejects filenames that do not follow this structure.

---

## Example of a Flagged File

Example:

```
lab_notes.txt
```

This file is flagged because it is not a FASTQ sequencing file and does not match the expected naming convention. The script leaves it untouched rather than attempting to rename it.

---

## Case-insensitive Matching

The script temporarily enables Bash's `nocasematch` option so that extensions like:

- `.FASTQ`
- `.fastq`
- `.Fq`

are all recognized correctly.

After processing, the option is disabled again so the script does not change the shell's behavior outside its execution.
