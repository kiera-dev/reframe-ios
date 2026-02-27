//
//  README.md
//  ReFrame
//

//

# ReFrame

ReFrame is a lightweight nervous system regulation app built in SwiftUI.

It provides structured, guided reset protocols for moments of panic, overwhelm, or anxiety.
                                                    
The end goal is to eventually connect with Meta Rayban, call up the app, and have Meta narrate in case of high anxiety or overwhelm.

<p align="center">
<img width="204" height="722" alt="image" src="https://github.com/user-attachments/assets/2c7a5319-1278-4878-b354-a715680e9cbe" />
<img width="204" height="722" alt="image" src="https://github.com/user-attachments/assets/fee0347c-4993-4086-832a-c27f037e3eab" />

</p>

---

## Included Protocols

- **Panic Spike Reset** — short grounding + breath + muscle release
- **STOP Protocol** — pause, observe, proceed intentionally
- **Rumination Loop Interrupt** — 5-4-3-2-1 sensory grounding
- **90-Second Micro PMR** — guided progressive muscle relaxation

---

## Architecture

### ResetEngine
Handles:
- Step sequencing
- Manual vs timed execution
- Timer lifecycle management

### PMRViewModel
- Observes engine
- Publishes instruction + helper text
- Controls session state

### ResetProtocol / ResetStep
Data-driven model defining:
- Instruction text
- Duration
- Step type
- Optional helper text
- Manual vs automatic mode

UI is fully state-driven via SwiftUI.

---

## Design Notes

- Transitions use soft fade animation.
- Circle animation is shown only for breath/muscle steps.
- Manual protocols use explicit user progression.
- Background theme uses static aura layers (no moving gradients).

---

## TBD
- Nicer UI
- Haptics for breath timing
- Progress indicators
- Background audio layer(?)
- Meta Rayban Wearable trigger integration

