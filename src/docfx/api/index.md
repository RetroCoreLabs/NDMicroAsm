# API Reference

Generated from the XML documentation of the NDMicroAsm project. The tree on the left lists every
namespace, type and member. Each CPU generation has its own namespace, holding its assembler,
disassembler, token table and field table:

| Namespace | CPU |
|---|---|
| `NDMicroAsm.Core` | shared by every assembler: labels, instructions, the assembled target |
| `NDMicroAsm.ND10` | NORD-10 and NORD-10/CE |
| `NDMicroAsm.ND1X0` | ND-110 and ND-120 |
| `NDMicroAsm.ND500` | ND-500 |
| `NDMicroAsm.ND5000` | ND-5000 (its token table builds on the ND-500 one) |
