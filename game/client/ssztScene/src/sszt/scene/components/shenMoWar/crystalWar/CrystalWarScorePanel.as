package sszt.scene.components.shenMoWar.crystalWar
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.profiler.showRedrawRegions;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.components.shenMoWar.crystalWar.score.CrystalWarScoreAllKillTabPanel;
	import sszt.scene.components.shenMoWar.crystalWar.score.CrystalWarScoreAllTabPanel;
	import sszt.scene.components.shenMoWar.crystalWar.score.CrystalWarScoreCampTabPanel;
	import sszt.scene.components.shenMoWar.crystalWar.score.CrystalWarScoreItemView;
	import sszt.scene.data.crystalWar.scoreInfo.CrystalWarScoreInfo;
	import sszt.scene.events.SceneCrystalWarUpdateEvent;
	import sszt.scene.mediators.SceneWarMediator;
	
	public class CrystalWarScorePanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneWarMediator;
		private var _mTile:MTile;
		private var _itemList:Array;
		private var _getRewardsBtn:MCacheAsset1Btn;
		private var _leaveBtn:MCacheAsset1Btn;
		private static const PAGE_SIZE:int = 10;
		private var _btns:Array;
		private var _panels:Array;
		private var _classes:Array;
		private var _currentIndex:int = -1;
		
		public function CrystalWarScorePanel(argMediator:SceneWarMediator)
		{
			_mediator = argMediator;
			_mediator.crystalWarInfo.initialScoreInfo();
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("sszt.scene.ShenMoMyWarInfoAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.scene.ShenMoMyWarInfoAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
			initialEvents();
			_mediator.sendCrystalWarRank();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(635,432);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,635,432)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,30,625,5),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(5,33,625,356)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(8,36,619,22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(7,81,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(7,109,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(7,137,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(7,165,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(7,193,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(7,221,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(7,249,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(7,278,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(7,306,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(7,334,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(7,362,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(7,390,595,2),new MCacheSplit2Line()),
			]);
			addContent(_bg as DisplayObject);
			
			var nameList:Array = [LanguageManager.getWord("ssztl.scene.totalKillRank"),
				LanguageManager.getWord("ssztl.scene.totalScoreRank"),
				LanguageManager.getWord("ssztl.scene.campRank")];
			_btns = [];
			_classes = [CrystalWarScoreAllKillTabPanel,CrystalWarScoreAllTabPanel,CrystalWarScoreCampTabPanel];
			_panels = [];
			var tmpBtn:MCacheTab1Btn;
			for(var i:int = 0;i < nameList.length;i++)
			{
				tmpBtn = new MCacheTab1Btn(0,1,nameList[i]);
				tmpBtn.move(i*67 + 23,8);
				_btns.push(tmpBtn);
				addContent(tmpBtn);
				tmpBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			
//			var label2:MAssetLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
//			label2.move(500,402);
//			addContent(label2);
//			label2.htmlText = LanguageManager.getWord("ssztl.scene.leaveWarAttention");
			
			_getRewardsBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.activity.getAward"));
			_getRewardsBtn.move(84,395);
			_getRewardsBtn.enabled = true;
			addContent(_getRewardsBtn);
			if(_mediator.sceneInfo.mapInfo.isCrystalWarScene())
			{
				_getRewardsBtn.enabled = false;
			}
			
			_leaveBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.leaveWar"));
			_leaveBtn.move(230,395);
			_leaveBtn.enabled = false;
			addContent(_leaveBtn);
			if(_mediator.sceneInfo.mapInfo.isCrystalWarScene())
			{
				_leaveBtn.enabled = true;
			}
		}
		
		private function initialEvents():void
		{
			_getRewardsBtn.addEventListener(MouseEvent.CLICK,btnWarClickHandler);
			_leaveBtn.addEventListener(MouseEvent.CLICK,btnWarClickHandler);
			crystalWarScoreInfo.addEventListener(SceneCrystalWarUpdateEvent.CRYSTAL_SCORE_INFO_UPDATE,updateTabData);
		}
		
		private function removeEvents():void
		{
			_getRewardsBtn.removeEventListener(MouseEvent.CLICK,btnWarClickHandler);
			_leaveBtn.removeEventListener(MouseEvent.CLICK,btnWarClickHandler);
			crystalWarScoreInfo.removeEventListener(SceneCrystalWarUpdateEvent.CRYSTAL_SCORE_INFO_UPDATE,updateTabData);
		}
		
		private function updateTabData(e:SceneCrystalWarUpdateEvent):void
		{
			index(0);
		}
		
		
		private function btnWarClickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _getRewardsBtn:
					getRewardBtnHandler();
					break
				case _leaveBtn:
					leaveBtnHandler();
				break;
			}
		}
		
		private function getRewardBtnHandler():void
		{
			_mediator.sendCrystalWarRewards(2);
		}
		
		private function leaveBtnHandler():void
		{
			if(!_mediator.sceneInfo.playerList.self.getIsCommon())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.inWarState"));
				return;
			}
			//			MAlert.show("确定要退出战场？,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,closeHandler);
			MAlert.show(LanguageManager.getWord("ssztl.scene.isSureLeaveWarScene"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,closeHandler);
			function closeHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					_mediator.sendCrystalWarLeave();
					_mediator.module.crystalWarScorePanel.dispose();
					
					GlobalData.selfPlayer.scenePath = null;
					GlobalData.selfPlayer.scenePathTarget = null;
					GlobalData.selfPlayer.scenePathCallback = null;
					if(_mediator && _mediator.module.sceneInit.playerListController.getSelf())_mediator.module.sceneInit.playerListController.getSelf().stopMoving();
				}
			}
		}
		
		private function clearList():void
		{
			_itemList.length = 0;
			_mTile.disposeItems();
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var argIndex:int = _btns.indexOf(e.currentTarget as MCacheTab1Btn);
			index(argIndex);
		}
		
		private function index(argIndex:int):void
		{
			if(_currentIndex == argIndex)return;
			if(_currentIndex != -1)
			{
				_btns[_currentIndex].selected = false;
				if(_panels[_currentIndex])
				{
					_panels[_currentIndex].hide();
				}
			}
			_currentIndex = argIndex;
			_btns[_currentIndex].selected = true;
			if(!_panels[_currentIndex])
			{
				_panels[_currentIndex] = new _classes[_currentIndex](_mediator);
				_panels[_currentIndex].move(5,33);
			}
			addContent(_panels[_currentIndex]);
			_panels[_currentIndex].show();
		}
		
			
		private function get crystalWarScoreInfo():CrystalWarScoreInfo
		{
			return _mediator.crystalWarInfo.crystalWarScoreInfo;
		}
		
		override public function dispose():void
		{
			removeEvents();
			_mediator.crystalWarInfo.clearScoreInfo();
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			for each(var i:MCacheTab1Btn in _btns)
			{
				i.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				i.dispose();
				i = null;
			}
			_btns = null;
			for(var j:int = 0;j < _panels.length;j++)
			{
				if(_panels[j])
				{
					_panels[j].dispose();
					_panels[j] = null;
				}
			}
			_panels = null;
			_classes = null;
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			for each(var m:CrystalWarScoreItemView  in _itemList)
			{
				if(m)
				{
					m.dispose();
					m = null;
				}
			}
			if(_getRewardsBtn)
			{
				_getRewardsBtn.dispose();
				_getRewardsBtn = null;
			}
			if(_leaveBtn)
			{
				_leaveBtn.dispose();
				_leaveBtn = null;
			}
			super.dispose();
		}
	}
}