local M  = {}

local Chain = {}
Chain.__index = Chain -- 메타테이블 설정: Chain 테이블에서 메소드를 찾도록 함

-- 생성자 함수 (새로운 Chain 인스턴스를 만듭니다)
function Chain.new(data)
  local self = {
    _data = data or {} -- 내부적으로 데이터를 저장할 필드
  }
  return setmetatable(self, Chain)
end

-- 필터링 메소드
function Chain:filter(predicate)
  local new_data = {}
  for _, v in ipairs(self._data) do
    if predicate(v) then -- filter는 키와 값 모두 받도록 유연하게
      table.insert(new_data, v)
    end
  end
  self._data = new_data -- 필터링된 데이터로 업데이트
  return self           -- 중요: self를 반환하여 체이닝 가능하게 함
end

-- 필터링 메소드
function Chain:filter_dict(predicate)
  local new_data = {}
  for k, v in pairs(self._data) do
    if predicate(v) then -- filter는 키와 값 모두 받도록 유연하게
      new_data[k] = v
    end
  end
  self._data = new_data -- 필터링된 데이터로 업데이트
  return self           -- 중요: self를 반환하여 체이닝 가능하게 함
end

-- 매핑 메소드 (새로운 값을 생성)
function Chain:map(mapper)
  local new_data = {}
  for i, v in ipairs(self._data) do
    new_data[i] = mapper(v) -- map은 값만 받도록 단순하게
  end
  self._data = new_data
  return self
end

-- 매핑 메소드 (새로운 값을 생성)
function Chain:map_dict(mapper)
  local new_data = {}
  for k, v in pairs(self._data) do
    new_data[k] = mapper(v) -- map은 값만 받도록 단순하게
  end
  self._data = new_data
  return self
end

-- 적용 메소드 (데이터를 제자리에서 수정)
function Chain:apply(mapper)
  for i, v in ipairs(self._data) do
    self._data[i] = mapper(v)
  end
  return self
end

-- 적용 메소드 (데이터를 제자리에서 수정)
function Chain:apply_dict(mapper)
  for k, v in pairs(self._data) do
    self._data[k] = mapper(v)
  end
  return self
end

-- 현재 데이터를 가져오는 메소드 (체이닝의 끝)
function Chain:get()
  return self._data
end

function M.from(tbl)
  return Chain.new(tbl)
end

return M
