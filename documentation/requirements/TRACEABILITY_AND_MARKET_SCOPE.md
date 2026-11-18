# Requirements and market traceability

## Requirements baseline

The SRS now uses hierarchical leaf identifiers such as `1.1.2`. Each leaf expresses one proposed `shall` requirement and includes a priority, verification method, provisional stakeholder groups, evidence basis, limitation, and status. `Requirement_ID_Crosswalk.csv` maps the former FR/NFR identifiers to the new baseline so references in earlier artifacts remain traceable. Use the dotted numeric identifiers for new work.

The SRS is a proposed design baseline, not evidence of implementation. Exact API contracts, physical schemas, role names, numeric thresholds, cgroup targets, and model internals remain unapproved or outside this SRS. A candidate SQLite schema and EERDs are now documented in `14_Data_Model` for team review; they do not change this SRS into an accepted implementation contract.

## Broader market scope

`Candidate_Market_Segments.csv` describes five candidate operating contexts, not validated customer segments. `Market_Need_to_Feature_Traceability.csv` contains 18 hypotheses connecting those contexts to technical evidence, alternatives, proposed features, hierarchical requirements, and local validation questions. `Market_Alternatives_Traceability.csv` compares technical approaches without claiming market share or product superiority.

Evidence classes distinguish official technical documentation, prior systems research, and project hypotheses. PSI/cgroup/systemd/Kubernetes references establish available mechanisms and constraints; they do not demonstrate local demand, adoption, willingness to pay, AIOS accuracy, safety, or performance. No local survey or interview responses are included. There are no TAM/SAM/SOM or market-size estimates.

## Validation path

Use the existing anonymous interview template only after supervisor/course ethics direction. Record consent and candidate context without collecting unnecessary identifying data. Update hypothesis status only when actual responses or controlled measurements are available; preserve contradictory and negative results.

