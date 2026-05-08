# Signed Form Assets

Put signed or approved recommendation and oral-defense approval pages here when building the final thesis.

Supported formats are PDF and common image formats accepted by LaTeX, such as PNG. Set the file paths in `config/metadata.tex`:

```tex
\NTUSTRecommendationFile{assets/forms/advisor_recommendation.pdf}
\NTUSTApprovalFile{assets/forms/approval.pdf}
```

If these values are left empty, the template renders placeholder pages.
