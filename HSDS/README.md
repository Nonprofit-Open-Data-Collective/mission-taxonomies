# Human Services Data Specification

The Open Referral Initiative develops data standards and open platforms that make it easy to share and find information about community resources. Learn more about the about at OpenReferral.org.

The [Human Services Data Specification (HSDS)](https://docs.openreferral.org/en/latest/hsds/overview.html) — also known as the Open Referral format — supports a taxonomy of services, but it does not enforce a single, required taxonomy. Instead, it provides a flexible structure that allows implementers to use or reference any taxonomy they choose, such as:

- AIRS/211 LA County Taxonomy of Human Services – The most widely used controlled vocabulary in the U.S. for classifying human services. However, it's proprietary and requires a license.
- [Open Eligibility Taxonomy](https://go.findhelp.com/hubfs/Partnerships/OpenEligibilityProject.pdf) – An [open-source taxonomy developed by Code for America](https://github.com/auntbertha/openeligibility), designed to be simple and accessible.
- Custom Local Taxonomies – Organizations can create and use their own classification systems.

## How HSDS Supports Taxonomies

In HSDS, taxonomies are implemented primarily through these fields:

- The taxonomy table defines the taxonomy systems used (e.g., Open Eligibility, AIRS). 
- The taxonomy_term table lists the individual terms from those taxonomies. 
- The service_taxonomy table links services to taxonomy terms (many-to-many relationship). 

This modular approach means that:

You can support multiple taxonomies in the same dataset.

You can specify which taxonomy each term comes from.

You retain semantic clarity while allowing for local or organizational flexibility.

## Example Use Case

```json

Copy
Edit
{
  "taxonomy": {
    "id": "1",
    "name": "Open Eligibility",
    "description": "An open taxonomy of human services."
  },
  "taxonomy_term": {
    "id": "101",
    "taxonomy_id": "1",
    "code": "food",
    "name": "Food Assistance",
    "description": "Programs that provide food support to individuals and families."
  },
  "service_taxonomy": {
    "service_id": "555",
    "taxonomy_term_id": "101"
  }
}
```

While HSDS does not impose a standard taxonomy, it provides a structure to document, reference, and share taxonomy-aligned data in a way that is interoperable across systems.

## Comparative Overview: AIRS/211 LA County vs. Open Eligibility Taxonomy

Below is a comparative overview of the AIRS/211 LA County Taxonomy of Human Services and the Open Eligibility Taxonomy. These two taxonomies serve as frameworks for categorizing human services, each with its unique structure and focus.

### Overview Table

| Feature                         | AIRS/211 LA County Taxonomy                                                                                                            | Open Eligibility Taxonomy                                                                                     |
|---------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|
| **Ownership & Licensing**       | Proprietary; maintained by 211 LA County; requires a paid license for full access.                                                     | Open-source; licensed under Creative Commons Attribution-ShareAlike 3.0 Unported.                             |
| **Scope & Depth**               | Comprehensive; over 9,200 terms covering a wide range of human services.                                                               | Simplified; focuses on core human services and situations.                                                    |
| **Structure**                   | Hierarchical; up to six levels deep, allowing for detailed categorization.                                                             | Flat or shallow hierarchy; emphasizes ease of use and simplicity.                                             |
| **Primary Use Cases**           | Utilized by professional information and referral (I&R) systems, including 2-1-1 centers and health/human service databases.            | Designed for public-facing platforms, such as online service directories and search tools.                    |
| **Facets/Term Types**           | Includes multiple facets: services, organizations, delivery modes, philosophies, programs, and target populations.                     | Divided into two main concepts: Human Services (e.g., housing, food) and Human Situations (e.g., veterans).   |
| **Target Populations**          | Features a dedicated section for target populations (e.g., older adults, individuals with disabilities).                               | Incorporates target populations within the "Human Situations" category.                                       |
| **Customization & Integration** | Offers tools for customization and integration into databases; supports cross-referencing with other classification systems.           | Designed for straightforward integration; suitable for developers and organizations seeking simplicity.       |
| **Maintenance & Updates**       | Regularly updated with new terms and revisions; subscribers receive updates to maintain current taxonomy.                              | Maintained by the community and organizations like HL7; updates are less frequent but accessible to all.      |

### Key Differences

- **Complexity vs. Simplicity**: The AIRS/211 LA County Taxonomy offers a detailed and complex structure suitable for professional environments, whereas the Open Eligibility Taxonomy provides a more straightforward approach ideal for public-facing applications.

- **Access and Licensing**: AIRS/211 LA County requires a paid license, limiting access to subscribers, while Open Eligibility is freely available under an open-source license.

- **Customization**: AIRS/211 LA County supports extensive customization and is designed for integration into comprehensive databases. Open Eligibility is more static but easier to implement for basic categorization needs.

### Examples of Service Categories

| Service Domain           | AIRS/211 LA County Taxonomy Example            | Open Eligibility Taxonomy Example |
|--------------------------|-----------------------------------------------|-----------------------------------|
| **Basic Needs**          | Food Pantries, Housing Expense Assistance     | Food, Housing                     |
| **Health Care**          | Audiology, Speech Therapy                     | Health                            |
| **Mental Health**        | Counseling Services, Psychiatric Services     | Mental Health                     |
| **Employment Services**  | Job Training, Employment Placement            | Employment                        |
| **Legal Services**       | Legal Counseling, Legal Representation        | Legal                             |
| **Education**            | Adult Education, Literacy Programs            | Education                         |
| **Substance Use**        | Substance Use Disorder Counseling             | Substance Abuse                   |
| **Transportation**       | Medical Transportation, Ride Sharing Programs | Transportation                    |

### Choosing the Right Taxonomy

- **AIRS/211 LA County Taxonomy** is ideal for organizations that require a comprehensive and detailed classification system, such as 2-1-1 centers, healthcare providers, and social service agencies.

- **[Open Eligibility Taxonomy](https://github.com/auntbertha/openeligibility)** is suitable for platforms that need a simple, open-source [taxonomy for categorizing services](https://go.findhelp.com/hubfs/Partnerships/OpenEligibilityProject.pdf), such as community resource directories and public-facing websites.


# Inform USA Standardsnfor excellence in information and referral

First published in 1973 and now in its 10th edition (Inform USA Standards and Quality Indicators for Professional Information and Referral - Version 10.0, officially released in July 2024), the Standards underpin and bind together every aspect of information and referral and define the direction of all our products and services. The Standards are the foundation of service delivery and the prime quality benchmark for community navigation. 

