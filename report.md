# Findings and Recommendations

## Status

The results below were recorded during an earlier analysis. They have **not yet been reproduced or verified** against the revised SQL pipeline. Do not treat them as final results until the queries are rerun against the original Olist dataset.

## 1. Product revenue by category

Previously recorded category results (category, item/order count as originally recorded, revenue, average price). The original query and count definition were not retained, so these figures are **historical notes**, not validated outputs from `sql/02_revenue_by_category.sql`.

| Category | Previously reported count | Previously reported revenue (BRL) | Previously reported average price (BRL) |
| --- | ---: | ---: | ---: |
| beleza_saude | 8,836 | 1,258,681.34 | 130.16 |
| relogios_presentes | 5,624 | 1,205,005.68 | 201.14 |
| cama_mesa_banho | 9,417 | 1,036,988.68 | 93.30 |
| esporte_lazer | 7,720 | 988,048.97 | 114.34 |
| informatica_acessorios | 6,689 | 911,954.32 | 116.51 |
| moveis_decoracao | 6,449 | 729,762.40 | 87.56 |
| cool_stuff | 3,632 | 635,290.85 | 167.36 |
| utilidades_domesticas | 5,884 | 632,248.66 | 90.79 |
| automotivo | 3,897 | 592,720.11 | 139.96 |
| ferramentas_jardim | 3,518 | 485,256.46 | 111.63 |
| brinquedos | 3,886 | 483,946.60 | 117.55 |
| bebes | 2,885 | 411,764.89 | 134.34 |
| perfumaria | 3,162 | 399,124.87 | 116.74 |
| telefonia | 4,199 | 323,667.53 | 71.21 |
| moveis_escritorio | 1,273 | 273,960.70 | 162.01 |

## 2. Delivery delay vs. review score

Previously recorded values:

| Delivery group | Previously reported orders | Previously reported average review score |
| --- | ---: | ---: |
| On time or early | 88,658 | 4.29 |
| 1–3 days late | 2,651 | 3.77 |
| More than 3 days late | 5,050 | 1.94 |

**Preliminary observation:** The earlier results suggest that longer delays are associated with lower review scores. The updated query groups reviews per order before calculating averages; totals may therefore differ. This is an association, not proof of causation.

## 3. Delivery performance by state

**Pending validation:** Run `sql/04_delivery_by_state.sql` and compare late-delivery percentages alongside delivered-order counts. Avoid ranking states by raw late-order counts alone, since states have different order volumes.

## Next analysis steps

1. Re-run all queries and replace the historical figures above with verified outputs.
2. Check whether category rankings change when restricting to delivered orders.
3. Visualize revenue by category, review score by delay group, and state-level late-delivery rates.
4. Develop recommendations only after validating the outputs and investigating meaningful differences.
