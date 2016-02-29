#========================================================================= 
# 本脚本来自[url]www.66RPG.com[/url]，使用和转载请保留此信息 
#========================================================================= 
# 空手的攻击防御力           by Claimh 
#------------------------------------------------------------------ 
# [url]http://www.k3.dion.ne.jp/~claimh/[/url] 
#======================================================================== 
module Arm_Element 
  ARM_ATK = [] 
  ARM_PDEF = [] 
  ARM_MDEF = [] 
  ARM_ELEMENT = [] 
  ARM_ELE_PLUS = [] 
  ARM_ELE_MINUS = [] 
  ARM_ANIMATION1 = [] 
  ARM_ANIMATION2 = [] 
  #=================================================================== 
  # 自定义开始 
  #==================================================================== 
  # 空手时1号角色攻击力与力量值的百分比关系(60%) 
  ARM_ATK[1] = 0.6 
  # 空手时2号角色攻击力与力量值的百分比关系(70%)，以下类推，不一一举例。 
  ARM_ATK[1] = 0.7 
 
  # 空手时1号角色防御力与灵巧值的百分比关系(60%) 
  ARM_PDEF[1] = 0.6 
 
  # 空手时1号角色魔法防御力与速度值的百分比关系(60%) 
  ARM_MDEF[1] = 0.6 
 
  # 空手时攻击方动画编号 
  ARM_ANIMATION1[1] = 1 
 
  # 空手时挨打方动画编号 
  ARM_ANIMATION2[1] = 4 
 
  #————以下几个慎用，是空手时的属性增减，不推荐修改 
 
  ARM_ELEMENT[1] = [1] 
  ARM_ELE_PLUS[1] = [] 
  ARM_ELE_MINUS[1] = [] 
end 
class Game_Actor < Game_Battler 
  include Arm_Element 
  #-------------------------------------------------------------------- 
  #------------------------------------------------------------------ 
  alias base_atk_arm base_atk 
  def base_atk 
    if @weapon_id == 0 and ARM_ATK[@actor_id] != nil 
      return $data_actors[@actor_id].parameters[2, @level] * ARM_ATK[@actor_id] 
    end 
    return base_atk_arm 
  end 
  #-------------------------------------------------------------------- 
  #------------------------------------------------------------------- 
  alias base_pdef_arm base_pdef 
  def base_pdef 
    if @weapon_id == 0 and ARM_PDEF[@actor_id] != nil 
      return base_pdef_arm + $data_actors[@actor_id].parameters[3, @level] * ARM_PDEF[@actor_id] 
    end 
    return base_pdef_arm 
  end 
 
  #-------------------------------------------------------------------- 
  #-------------------------------------------------------------------- 
  alias base_mdef_arm base_mdef 
  def base_mdef 
    if @weapon_id == 0 and ARM_MDEF[@actor_id] != nil 
      return base_mdef_arm + $data_actors[@actor_id].parameters[4, @level] * ARM_MDEF[@actor_id] 
    end 
    return base_mdef_arm 
  end 
  #------------------------------------------------------------------ 
  #-------------------------------------------------------------- 
  alias element_set_arm element_set 
  def element_set 
    if @weapon_id == 0 and ARM_ELEMENT[@actor_id] != [] 
      return ARM_ELEMENT[@actor_id] 
    end 
    return element_set_arm 
  end 
  #----------------------------------------------------------------- 
  #------------------------------------------------------------------- 
  alias plus_state_set_arm plus_state_set 
  def plus_state_set 
    if @weapon_id == 0 and ARM_ELE_PLUS[@actor_id] != [] 
      return ARM_ELE_PLUS[@actor_id] 
    end 
    return plus_state_set_arm 
  end 
 
  #------------------------------------------------------------------- 
  #------------------------------------------------------------------ 
  alias minus_state_set_arm minus_state_set 
  def minus_state_set 
    if @weapon_id == 0 and ARM_ELE_MINUS[@actor_id] != [] 
      return ARM_ELE_MINUS[@actor_id] 
    end 
    return minus_state_set_arm 
  end 
  #------------------------------------------------------------------ 
  #----------------------------------------------------------------- 
  alias animation1_id_arm animation1_id 
  def animation1_id 
    if @weapon_id == 0 and ARM_ANIMATION1[@actor_id] != nil 
      return ARM_ANIMATION1[@actor_id] 
    end 
    return animation1_id_arm 
  end 
 
  #--------------------------------------------------------------------- 
  #------------------------------------------------------------------ 
  alias animation2_id_arm animation2_id 
  def animation2_id 
    if @weapon_id == 0 and ARM_ANIMATION2[@actor_id] != nil 
      return ARM_ANIMATION2[@actor_id] 
    end 
    return animation2_id_arm 
  end 
end 
 
#===================================================================== 
# 本脚本来自[url]www.66RPG.com[/url]，使用和转载请保留此信息 
#=====================================================================
