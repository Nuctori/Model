local class = require "class"

local assert = assert

local fmt = string.format
local toint = math.tointeger
local tconcat = table.concat

local SmallInt = class("SmallInt")

function SmallInt:ctor(opt)
  self.auto_increment = opt.auto_increment   -- 自增
  self.comment = opt.comment                 -- 注释
  self.unsigned = opt.unsigned               -- 无符号
  self.default = opt.default                 -- 默认值
  self.primary = opt.primary                 -- 主键
  self.null = opt.null                       -- NULL
  self.name = opt.name                       -- 字段名
end

-- 验证字段传值有效
function SmallInt:verify(x)
  x = assert(toint( x ), fmt("`%s` field was passed a invalid value(`SmallInt`).", self.name))
  if self.unsigned then
    return x >= 0 and x <= 65535
  end
  return x >= -32768 and x <= 32767
end

-- 是否为自增
function SmallInt:isAutoIncrement()
  return self.auto_increment
end

-- 是否为主键
function SmallInt:isPrimary()
  return self.primary
end

-- 将字段转DDL语句
function SmallInt:toSqlDefine()
  local DDL = {" "}
  DDL[#DDL+1] = fmt([[`%s`]], self.name)
  DDL[#DDL+1] = self.unsigned and "SMALLINT UNSIGNED" or "SMALLINT"
  DDL[#DDL+1] = self.null and "NULL" or "NOT NULL"
  if self.default then
    if self.default == null then
      DDL[#DDL+1] = "DEFAULT 'NULL'"
    else
      DDL[#DDL+1] = fmt("DEFAULT '%s'", self.default)
    end
  end
  if self.auto_increment then
    DDL[#DDL+1] = "AUTO_INCREMENT"
  end
  if self.comment then
    DDL[#DDL+1] = fmt("COMMENT '%s'", self.comment)
  end
  return tconcat(DDL, " ")
end

return function (meta)
  return SmallInt:new(assert(meta))
end