#include <llvm/Analysis/LoopPass.h>
#include <llvm/Analysis/ValueTracking.h>

using namespace llvm;

namespace {

class LoopWalkPass final : public LoopPass {
public:
  static char ID;

  LoopWalkPass() : LoopPass(ID) {}

  virtual void getAnalysisUsage(AnalysisUsage &AU) const override {
    DominatorTree* DT = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  }

  virtual bool runOnLoop(Loop *L, LPPassManager &LPM) override {
    outs() << "LOOPPASS INIZIATO...\n";

    if(L->isLoopSimplifyForm())         // alias per forma normale dei loop
      outs() << "\nil loop è canonico\n";

    BasicBlock* preheader = L->getLoopPreheader();
    if(preheader)
    {
      outs() << "\nil loop ha un preheader.\nISTRUZIONI PREHEADER\n";
      for(Instruction &i : *preheader)
        outs() << i << "\n";
    }

    uint counter = 1;
    outs() << "\nBASIC BLOCK DEL LOOP\n";
    for(auto& bb : L->getBlocks())
    {
      outs() << "\nBB: ";
      bb->printAsOperand(outs(), false);
      outs() << "\n";

      for(auto& i : *bb)
        outs() << i << "\n";

      counter++;
    }
    outs() << "\n\n";

    //Esercizio 2
    for(auto& bb : L->getBlocks())
    {
      for(auto& i : *bb)
      {
        if(i.getOpcode() == Instruction::Sub)
        {
          outs() << "Sono una sub.\n";

          Instruction* opR = dyn_cast<Instruction>(i.getOperand(0));
          Instruction* opL = dyn_cast<Instruction>(i.getOperand(1));

          if(opR)
          {
            outs() << "BB di Op Right: ";
            opR->getParent()->printAsOperand(outs(), false);
            outs() << "\n";
          }
          if(opL)
          {
            outs() << "BB di Op Left: ";
            opL->getParent()->printAsOperand(outs(), false);
            outs() << "\n";
          }
        }
      }

      counter++;
    }
    return false; 
  }
};

char LoopWalkPass::ID = 0;
RegisterPass<LoopWalkPass> X("loop-walk",
                             "Loop Walk");

} // anonymous namespace

