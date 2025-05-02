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
  #set align(top)
  *seL4*: A minimalistic #stress("open source") microkernel providing core OS services:
    - Process and thread management
    - Memory isolation via capabilities
    - Secure inter-process communication (IPC)
  
  *Key Features*: 
    - Strong isolation: Programs run in "sandboxes," preventing interference.
    - Optimized for resource-constrained devices.
    - Supports ARM, x86, RISC-V architectures.
    - Formally verified for functional correctness.
]

#slide(title: "Applications in Critical Systems")[
  #set align(top)
  Widely used in high-stakes systems:
    1. Aviation (e.g., Boeing, DARPA projects)
    2. Medical devices (e.g., pacemakers)
    3. Cybersecurity (e.g., secure smartphones)
    4. Autonomous vehicles
    5. Military systems (e.g., DARPA HACMS)
    6. Internet of Things (IoT)
  
  *Why seL4?*
    - Verified reliability: Guarantees no crashes or vulnerabilities.
    - Ideal for life-critical and high-security applications.
]

#slide(title: "Benefits of Formal Verification")[
  #set align(top)
  #colorbox()[
    *Verification*: Mathematical proof that the kernel adheres to its specification in all possible scenarios.
  ]
  == Why It Matters
    - *Reliability*: Eliminates crashes, even in edge cases.
    - *Security*: Prevents exploitable bugs.
    - *Certification*: Meets standards like Common Criteria, DO-178C.
    - *Uniqueness*: First fully verified general-purpose microkernel.
  
  #line(length: 100%)
  
  #set align(bottom)
  #hint-box()[  
    *Common Criteria* and *DO-178C* are standards for software security and safety certification.
  ]
]

#slide(title: "Additional Details")[
  #set align(top)
  == Development
  Developed by NICTA (Australia) starting in the 2000s. Completed in 2009, fully verified by 2014.
  
  Currently maintained by Data61, led by Gernot Heiser.
  
  #line(length: 100%)
  
  == Code
  Written in *C* (~8,700 lines) and *assembly* (~600 lines), totaling ~9,300 lines verified using #stress("Isabelle/HOL").
  
  *License*: GPLv2 for open source; commercial licenses available.
  
  #hint-box()[
    Source code available on 
    #show link: underline
    #link("https://github.com/seL4/seL4")[GitHub]
  ]
]

/// MARK: - Isabelle/HOL
#title-slide[ Isabelle/HOL: The Verification Powerhouse ]

#slide(title: "What is Isabelle/HOL?")[
  #set align(top)
  #colorbox()[
    *Isabelle/HOL*: An interactive proof assistant using higher-order logic (HOL) for formal verification.
  ]
  Isabelle based on ITP - #stress("Interactive Theorem Proving")
  
  == Key Features
  - *Interactive Proofs*: Combines human insight with machine-checked accuracy.
  - *Higher-Order Logic*: Models complex systems like operating systems.
  - *Versatile*: Verifies software, hardware, and protocols.

  == How It Works
  - You define a program and its desired properties (e.g., "no errors").
  - Write *proof scripts* to show the properties hold.
  - Isabelle checks each step, ensuring correctness.
  
]


#slide(title: "Example 1: Proving a Sum Function")[
  #set align(top)
  == Goal
  #colorbox()[Prove a function `sum_upto(n)` computes `1 + 2 + ... + n` correctly.]

  ```isabelle
  fun sum_upto :: "nat ⇒ nat" where
    "sum_upto 0 = 0"
  | "sum_upto n = n + sum_upto (n - 1)"
  
  theorem sum_correct:                # Define theorem to prove
    "sum_upto n = (n * (n + 1)) div 2"
  proof (induction n)                 # Proving by induction on variable n
    case 0 show ?case by simp         # Prove case 0 by substitution 
    case (Suc n) thus ?case by simp   # Prove case n + 1 by substitution
  qed
  ```
  #hint-box()[in _case_ clauses substitutes arg to formula from definition ]
  
  == Explanation
  - Defines `sum_upto` recursively.
  - Proves it equals the formula `n * (n + 1) / 2` using induction.
  - Isabelle checks each case (base and step).
  
  === base
  ```isabelle
  sum_upto 0 = (0 * (0 + 1)) div 2
  0 * (0 + 1) div 2 = 0
  ```
  #line(length: 100%)
  === step
  ```isabelle
  sum_upto (Suc n) = ((Suc n) * (Suc n + 1)) div 2
  Suc n + (n * (n + 1)) div 2 = ((Suc n) * (Suc n + 1)) div 2
  
  ```
]

#slide(title: "Example 2: Proving List Reversal")[
  #set align(top)
  == Goal
  #colorbox()[Prove reversing a list preserves its length.]
  
  ```isabelle
  fun reverse :: "'a list ⇒ 'a list" where
    "reverse [] = []"
  | "reverse (x # xs) = reverse xs @ [x]"   # [x] + [y...z] = [z...y] + [x]
  
  theorem reverse_length:
    "length (reverse xs) = length xs"       
    proof (induction xs) 
      case Nil show ?case by simp           # case Nil when list is empty 
      case (Cons x xs) thus ?case by simp   # case [x] + xs
    qed
  ```
  
  == Explanation
  - Defines `reverse` recursively: empty list stays empty; otherwise, move head to end.
  - Proves `length (reverse xs) = length xs` using induction.
  - Isabelle verifies base case (empty list) and step case (non-empty list).
  
  #colorbox()[
    This guarantees `reverse` doesn’t add or lose elements.
  ]
  === base
  ```isabelle
  length(reverse[]) = length[]
  length [] = length []
  ```
  === step
  ```isabelle
  length(reverse(x # xs)) = length(x # xs)
  length(reverse xs @ [x]) = length(xs) + 1
  length(reverse(xs)) + length([x]) = length(xs) + 1
  ```
]

#slide(title: "Examples outcome")[
  #set align(top)
  == Lessons Learned
  - *Modeling*: Programs are defined as mathematical functions.
  - *Proofs*: Use induction or other logic to cover all cases.
  - *Verification*: Isabelle ensures no mistakes in reasoning.
  
  == In seL4 Context
  - Similar techniques scaled to prove complex properties (e.g., memory safety).
  - Simple proofs build confidence for larger systems.
]

#slide(title: "Why Isabelle is chosen?")[
  #set align(top)
  #colorbox()[As mentioned before, *Isabelle/HOL* uses ITP, which is perfect for a such large project as seL4 (10k LOC). Other methods of verification would take enormous amount of time and resources.]
]

/// MARK: - Verification Process
#title-slide[ Verifying seL4: Process and Insights ]

#slide(title: "What is Formal Verification?")[
  #set align(top)
  #colorbox()[
    *Formal Verification*: Mathematically proving a system behaves correctly for *all* inputs and scenarios.
  ]
  
  == Why It Matters
  - Ensures *bug-free* behavior, unlike testing (limited cases).
  - Critical for seL4’s use in safety-critical systems (e.g., pacemakers).
  
  == Example
  - Proved seL4’s memory isolation prevents unauthorized access.
]

#slide(title: "seL4 Verification Methodology")[
  #set align(top)
  #cols(columns: (1fr, 1fr))[
    == Approach
    - Used *Isabelle/HOL* for machine-checked proofs.
    - Proved *functional correctness* via refinement:
      - Abstract spec → Executable spec → C code.
    - Prototyped in *Haskell* for design clarity.
    
    == Refinement Layers
    - *Abstract*: Defines *what* (e.g., system calls).
    - *Executable*: Details *how* (Haskell-derived).
    - *Concrete*: C code (~8,700 LOC).
    

  ][
    #set align(horizon)
    #figure(
      image("assets/refinement_layers.png"),
      caption: "The refinement layers"
    )
  ]
]
// TODO: maybe separate title slide
#slide(title: "Refinement")[
  #set align(top)
  === Correspondence
  A refinement proof establishes a
correspondence between a high-level (abstract) and
a low-level (concrete, or refined ) representation of a
system.

The correspondence established by the refinement
proof ensures that all Hoare logic properties of the
abstract model #stress("also hold for the refined model"). This
means that if a security property is proved in Hoare
logic about the abstract model (not all security properties can be), refinement guarantees that the same
property holds for the kernel source code. 
]

#slide(title: "Example: Capability Derivation Tree")[
  #set align(top)
  == Concept
  - Tracks memory allocation via capabilities to prevent dangling references.
  - Implemented as a doubly-linked list for simplicity.
  
  == Isabelle/HOL Proof
  ```isabelle
  invariant cdt_list s = (∀c. cdt s c ≠ None ⟶
    ∃p. cdt s p = Some c ∧ valid_mdb s)
  ```
  - Ensures every capability has a valid parent, preserving memory safety.
  
  #hint-box()[
    This invariant guarantees safe memory management.
  ]
]



#slide(title: "Managing Concurrency")[
  #set align(top)
  == Challenge
  Concurrency (e.g., interrupts) complicates proofs.
  
  == seL4’s Approach
  - *Event-Based*: Single kernel stack, mostly non-preemptable.
  - *Interrupt Polling*: Controlled preemption points.
  - *Zombie Capabilities*: Store state for safe object destruction.
  
  == Example
  - Interrupt retries ensure invariants (e.g., queue integrity) are restored.
  
  #hint-box()[
    Simplified concurrency kept proofs manageable.
  ]
]

#slide(title: "Verification Challenges: Code and Semantics")[
  #set align(top)
  == Key Issues
  - *Global Variables*: Proved invariants (e.g., list integrity) across all code.
  - *C Semantics*: Defined a C99 subset, avoiding complex features (e.g., function pointers).
  
  == Example
  - Proved `ksReadyQueues` updates in `setPriority` maintain list consistency.
  
  #hint-box()[
    Formal C semantics were critical for accurate proofs.
  ]
]

#slide(title: "Verification Challenges: Invariants")[
  #set align(top)
  == Complexity
  - Proved over 150 invariants (e.g., type safety, no null pointers).
  - Invariants often interdependent, requiring careful proof ordering.
  
  == Example
  - *Reply Capability Issue*: Adding reply capabilities broke existing invariants, needing 1 person-year to fix.
  
  #hint-box()[
    Invariants took ~80% of proof effort!
  ]
]

/// MARK: - Example
#title-slide("Example: Scheduler")

#slide(title: "Example: Abstract Scheduler")[
  #set align(top)
  == Scheduler Specification
  The abstract specification defines *what* the scheduler does, not *how*.
  
  ```isabelle
  schedule = do
    threads = all_active_tcbs;
    thread = select threads;
    switch_to_thread thread
  od OR switch_to_idle_thread
  ```
  
  == Explanation
  - *Non-deterministic*: Picks any runnable thread or idle thread.
  - Leaves implementation details (e.g., priority) to lower layers.
  
  #hint-box()[
    This simplicity makes proving correctness easier!
  ]
]

#slide(title: "Example: Executable Scheduler")[
  #set align(top)
  == Detailed Scheduler
  The executable specification adds *how* the scheduler works.
  
  ```isabelle
  schedule = do
    action <- getSchedulerAction
    case action of
      ChooseNewThread -> do
        chooseThread
        setSchedulerAction ResumeCurrentThread
  chooseThread = do
    r <- findM chooseThread' (reverse [minBound .. maxBound])
    ...
  ```
  #cols(columns: (1.5fr, 1fr))[
      == Key Points
  - Uses priority-based round-robin scheduling.
  - Explicit data structures (e.g., priority queues).
  ][
    #hint-box()[
      This bridges the abstract spec to the C implementation.
    ]
  ]
]

#slide(title: "Example: C Scheduler")[
  #set align(top)
  == C Implementation
  The final C code optimizes performance while matching the spec.
  
  == Why It Matters
  - Verified to match the executable spec.
  - Handles thread priority updates safely.
]

#slide(title: "Example: C Scheduler Code")[
    ```c
  void setPriority(tcb_t *tptr, prio_t prio) {
      prio_t oldprio;
      if (thread_state_get_tcbQueued(tptr->tcbState)) {
          ksReadyQueues[oldprio] =
              tcbSchedDequeue(tptr, ksReadyQueues[oldprio]);
          if (isRunnable(tptr)) {
              ksReadyQueues[prio] =
                  tcbSchedEnqueue(tptr, ksReadyQueues[prio]);
          } else {
              thread_state_ptr_set_tcbQueued(&tptr->tcbState, false);
          }
      }
      tptr->tcbPriority = prio;
  }
  ```
]

/// MARK: - Conclusion
#title-slide[ Conclusion ]

#slide(title: "Lessons Learned")[
  #set align(top)
  == Key Takeaways
  - *Haskell Prototype*: Reduced development costs and improved design.
  - *Verification-Driven Design*: Led to simpler, more robust code.
  - *Cost of Change*: Local changes are cheap; cross-cutting changes (e.g., reply capabilities) are expensive.
  - *Bug Detection*: Found subtle bugs (e.g., missing input checks) missed by testing.
  
  == Future Work
  - Verify assembly code and boot process.
  - Extend to multi-core systems.
  - Support application-level verification.
]

#slide(title: "Effort and Outcomes")[
  #set align(top)
  == Effort
  - *Total*: ~20 person-years (11 for seL4-specific proofs).
  - *Proof Size*: 200,000 lines of Isabelle/HOL scripts.
  - *Bugs Found*: 144 in C code, fixed during verification.
  
  == Achievements
  - *Correctness*: C code matches abstract spec.
  - *Safety*: No crashes or null pointer errors.
  - *Security*: Access control verified.
  - *Performance*: IPC at 224 cycles, matching optimized kernels.
  
  #hint-box()[
    Verification cost (~8 person-years for a new kernel) rivals traditional development.
  ]
]

#slide(title: "Impact of Isabelle/HOL in seL4")[
  #set align(top)
  == Contributions
  - Enabled first fully verified general-purpose microkernel.
  - Caught subtle bugs (e.g., incorrect interrupt checks).
  - Set a new standard for OS trustworthiness.
  
  == Broader Impact
  - Supports critical systems (e.g., aviation, medical).
  - Inspires verification in other domains.
  
  #hint-box()[
    Isabelle/HOL made seL4 a gold standard for security.
  ]
]

#slide(title: "Summary")[
  #set align(top)
  - *seL4*: First fully verified general-purpose microkernel, ensuring unmatched reliability and security.
  - *Verification*: Proved functional correctness using Isabelle/HOL, covering ~9,300 LOC.
  - *Impact*: Enables trusted systems in aviation, medical, military, and more.
  - *Legacy*: Redefines standards for OS assurance, with practical development costs.
  
  #hint-box()[
    Visit 
    #show link: underline
    #link("https://sel4.systems")[seL4.systems] for more information.
  ]
]
