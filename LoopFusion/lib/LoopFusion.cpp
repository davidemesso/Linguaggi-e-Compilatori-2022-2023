#include <llvm/Analysis/LoopPass.h>
#include <llvm/Analysis/ValueTracking.h>
#include <llvm/Analysis/PostDominators.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/IR/IRBuilder.h>

using namespace llvm;

namespace {

class LoopFusionPass final : public FunctionPass {
public:
  static char ID;

  LoopFusionPass() : FunctionPass(ID) {}

  virtual void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<DominatorTreeWrapperPass>();
    AU.addRequired<LoopInfoWrapperPass>();
    AU.addRequired<ScalarEvolutionWrapperPass>();
    AU.addRequired<PostDominatorTreeWrapperPass>();
  }

  virtual bool runOnFunction(Function &F) override {
    // strutture dati utili per il passo
    DominatorTree* DT = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();
    PostDominatorTree* PDT = &getAnalysis<PostDominatorTreeWrapperPass>().getPostDomTree();
    LoopInfo* LI = &getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
    ScalarEvolution* SE = &getAnalysis<ScalarEvolutionWrapperPass>().getSE();

    outs() << "LOOPFUSION INIZIATO...\n";

    SmallVector<Loop*> AllLoops = LI->getLoopsInPreorder();
    SmallVector<Loop*> checkedLoops;

    for(auto &loop: AllLoops)
    {
       if(loop->isLoopSimplifyForm() && loop->getExitBlock() && checkPreheader(loop)) {
        loop->print(outs(), false);
        outs() << "is in simplified form and is ok for adjacency control\n";
        checkedLoops.push_back(loop);
      }
    }
    outs() << "\n";

    for(auto &i: AllLoops) {
      for(auto &l: checkedLoops) {
        if(i == l)
          continue;
        
        auto preheader = l->getLoopPreheader();
        auto exitBlock = i->getExitBlock();

        if(exitBlock != preheader)
          continue;

        l->print(outs(), false);
        outs() << " is adjacent to: ";
        i->print(outs(), false);

        if(!checkTripCount(*SE, i, l))
          continue;

        outs() << "\nThe two loops have been checked on trip count and loop bounds\n";

        if(!DT->dominates(i->getExitBlock(), l->getLoopPreheader()))
          continue;
        if(!PDT->dominates(l->getLoopPreheader(), i->getExitBlock()))
          continue;
        
        outs() << "\nThe two loops are control flow equivalent\n";

        loopFusion(LI, i, l);
      }
    }
    return true;
  }

private:
  bool checkPreheader(Loop* l) {
    auto preheader = l->getLoopPreheader();
    
    if(preheader->getInstList().size() != 1)
      return false;
    
    for(auto &inst: preheader->getInstList()) {

      if(inst.getOpcode() != Instruction::Br)
        return false;
      
      auto op = inst.getOperand(0);
      
      return op == l->getHeader();
    }
    return true;
  }

  bool checkTripCount(ScalarEvolution& SE, Loop* i, Loop* l) {

    if(SE.getSmallConstantTripCount(i) != SE.getSmallConstantTripCount(l))
      return false;

    if(!i->getCanonicalInductionVariable() || !l->getCanonicalInductionVariable())
      return false;

    return true;
  }

  void loopFusion(LoopInfo* LI, Loop* i, Loop* l) {

    SmallVector<BasicBlock*> blocks;
    for(auto& bb : l->getBlocks()) {      
      if(bb == l->getHeader())
        continue;
      
      if(bb == l->getLoopLatch())
        continue;
      
      blocks.push_back(bb);
    }
    
    // replace the IV of the second loop with the IV of the first one
    Value* phiFirstLoop = &i->getHeader()->getInstList().front();
    Instruction* phiSecondLoop = &l->getHeader()->getInstList().front();
    phiSecondLoop->replaceAllUsesWith(phiFirstLoop);

    BasicBlock* bodyFirstLoop = nullptr;
    for(auto& bb : i->getBlocks()) {
      if(bb == i->getHeader())
        continue;
      bodyFirstLoop = bb;
      break;
    }

    Instruction* branchFirstLoop = nullptr;
    for(auto& inst : bodyFirstLoop->getInstList())
        if(inst.getOpcode() == Instruction::Br) {
          branchFirstLoop = &inst;
          break;
        }

    // TODO: move body of second loop next to the body of the first one
    for(auto& bb : blocks) {
      bb->replaceAllUsesWith(l->getLoopLatch());
      bb->moveBefore(i->getLoopLatch());
      /*
      for(auto& inst : bb->getInstList()) {
        if(inst.getOpcode() == Instruction::Br) {
          inst.setSuccessor(1, branchFirstLoop->getSuccessor(1));
        }
      }
      branchFirstLoop->setSuccessor(2, bb);
      */
    }
  }
};

char LoopFusionPass::ID = 0;
RegisterPass<LoopFusionPass> X("fusion",
                             "Loop Fusion");

} // anonymous namespace

