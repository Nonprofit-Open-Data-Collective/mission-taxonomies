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


# Inform USA Standards for excellence in information and referral

First published in 1973 and now in its 10th edition (Inform USA Standards and Quality Indicators for Professional Information and Referral - Version 10.0, officially released in July 2024), the Standards underpin and bind together every aspect of information and referral and define the direction of all our products and services. The Standards are the foundation of service delivery and the prime quality benchmark for community navigation. 

See: https://www.informusa.org/standards

The Inform USA Standards Committee is pleased to release the 10th edition of the *Inform USA Standards and Quality Indicators for Professional Information and Referral*.  

The Inform USA [Standards](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.uifuz6ku078e) provide guideposts to quality and define expected [practices](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.gwvez6zhrm8q) within the field of Information and Referral (I&R).  [Quality Indicators](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.af8t0crfhg8r) (QIs) provide concrete examples of processes or outcomes that can determine quality. 

[I&R services](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.ri1je5l6jxt2) help bring individuals and families together with the programs within the human service delivery system. I&R programs develop working relationships with human service providers and larger service systems to advance an integrated service delivery system. They also facilitate long-range planning by tracking service requests and identifying gaps and duplications in communities. 

Note that the Older Americans Act uses the phrase "[Information and Assistance](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.wcgbvs1thr01)" (or I&A) which is sometimes used within the sector. 

Community Resource Specialists help people better understand their problems/needs and make informed decisions about possible solutions. Specialists may advocate on behalf of those who need additional support and reinforce an individual's capacity for self-reliance and [self-determination](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.xd9wo3n9utei).  Database Curators create, maintain, and disseminate information on the [programs](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.p6mi0pkenkzq) and [services](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.71842fkyss3w) delivered within the [human services](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.bd9l29z03ybe) sector.  

The Standards are the foundation for [credentialing](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.tp4ekvkp2fnn)[ ](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=id.3ivniagouex8)programs, whether it is [Inform USA Accreditation](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.v4kwteswb0sz) for I&R programs, or [Inform USA Certification](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.v7eis9jh29y3) for individual practitioners as either [Certified Community Resource Specialist (CRS)](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.i8vq8mfxoynz), [Certified Community Resource Specialist - Aging/Disabilities (CRS-A/D)](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.mrlsm4a9md4r), and/or [Certified Resource Specialist -- Database Curators (CRS-DC)](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.6eoa6h8xizib). 

The Standards address all aspects of an I&R program. They define the information and referral process in concrete terms; establish criteria for database development; mandate support for community planning activities; incorporate a broad view of collaboration at the local, state, provincial, territory and/or federal levels; include provisions for the responsible use of technology; describe the role of I&R services in times of disaster; and outlines ongoing [quality assurance](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.ana2lbkc4jpt) processes. 

Structure of the Standards document: *High-quality, standards-driven I&R services happen when all parts of the organization work together to provide the best experience for each person in need. This involves clear *[*policies*](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.3sln8spo8fji)* and/or *[*procedures*](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.1ue9h9pghbc)*, quality training and supervision, attentive contact handling and accurate resource curation. To highlight this concept, when applicable, the quality indicators are grouped into 3 areas: *

-   *Organizational Quality Indicators (Policies/Procedures) **for the administrative organization which includes considerations regarding policies or procedures *

-   *Oversight Quality Indicators (Supervision/Coaching/Training) **for the service's management activities including supervision/coaching/training*

-   *Practice Quality Indicators (Staff/Volunteer Expectations) **for the daily practice/frontline service provision which focuses on staff/volunteer expectations*

Where do I go for more detailed information about how to implement these Standards?  

There are two other Inform USA resources to assist members who want to learn even more about how to apply the concepts outlined in the Standards: 

-   [Inform USA Accreditation](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.v4kwteswb0sz) is the process by which I&R programs are evaluated against the industry Standards for information and referral. The Accreditation Manual is the guiding document that outlines the five phases of the process. It also contains requirements that must be met in order to achieve full accreditation.

-   [Inform USA I&R Training Manual](https://docs.google.com/document/d/1bqhZyUE8Wo5vSh8nqTxITlmMldWVja7C2qUrSHryOus/edit#bookmark=kix.yqqmzjfx6s83) references the Standards and has more in-depth content for training purposes. It can help I&R practitioners gain an understanding of how to put the Standards into practice. The Training Manual contains topics for discussion, role plays, and relevant concepts.
