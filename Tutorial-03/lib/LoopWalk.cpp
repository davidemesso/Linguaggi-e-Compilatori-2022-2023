#include <llvm/Analysis/LoopPass.h>
#include <llvm/Analysis/ValueTracking.h>

using namespace llvm;

namespace {

class LoopWalkPass final : public LoopPass {
public:
  static char ID;

  LoopWalkPass() : LoopPass(ID) {}

  virtual void getAnalysisUsage(AnalysisUsage &AU) const override {
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
    outs() << "\nBASIC BLOCK DEL LOOP";
    for(auto& bb : L->getBlocks())
    {
      outs() << "\nBB n°" << counter << "\n";

      for(auto& i : *bb)
        outs() << i << "\n";

      counter++;
    }
    outs() << "\n";

    return false; 
  }
};

char LoopWalkPass::ID = 0;
RegisterPass<LoopWalkPass> X("loop-walk",
                             "Loop Walk");

} // anonymous namespace

