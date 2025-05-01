#import "config.typ": *


#show: typslides.with(
  ratio: "16-9",
  theme: "purply",
)

#front-slide(
  title: "seL4 Verification",
  authors: "Danil Tolstov",
  info: "Group: M3302",
)

#table-of-contents()

/// MARK: - Overview
#title-slide[ Overview of seL4 ]

#slide(title: "Key Features of seL4 Microkernel")[
  - *What is seL4?* A minimalistic #stress("open source") microkernel providing core OS services:
    - Process and thread management
    - Memory isolation
    - Secure inter-process communication
  - *Key Feature*: Strong isolation ensures programs run in "sandboxes," preventing interference.
  - *Performance*: Optimized for resource-constrained devices.
  - *Supported Architectures*: ARM, x86, RISC-V.
]

#slide(title: "Applications in Critical Systems")[
  - *Use Cases*:
    - Aviation (e.g., Boeing, DARPA projects)
    - Medical devices (e.g., pacemakers)
    - Cybersecurity (e.g., secure smartphones)
    - Autonomous vehicles
    - Military systems (e.g., DARPA HACMS)
  - *Why seL4?*
    - Verified reliability: No crashes or vulnerabilities.
    - Ideal for life-critical and high-security systems.
]

#slide(title: "Benefits of Formal Verification")[
  - *What is Verification?* Mathematical proof that seL4 works as intended for all cases.
  - *Why It Matters*:
    - *Reliability*: No crashes, even in edge cases.
    - *Security*: Eliminates exploitable bugs.
    - *Trust*: Used by Boeing, DARPA, etc.
    - *Certification*: Meets standards like Common Criteria, DO-178C.
  - *Uniqueness*: seL4 is the first fully verified general-purpose microkernel.
]

#slide(title: "Additional Details")[
  - *Created*: Started in 2000s, released in 2009, fully verified by 2014.
  - *Developers*: NICTA/Data61 (CSIRO), led by Gernot Heiser.
  - *Language*: Written in C, with critical parts in assembly. Verified using Isabelle/HOL.
  - *Size*: The seL4 microkernel contains 8,830 lines of C and 600 lines of assembler, totaling ~9,430 lines, all of which were formally verified.
  - *License*: GPLv2 for open source; commercial licenses available.
]
