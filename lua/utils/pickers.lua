local M = {}
function M.history()
  -- require("utils.pickers").picker_history()
  local resume_mod = require("snacks.picker.resume")
  local history_states = resume_mod.state

  -- Define the name we want to ignore
  local ignore_source = "picker_history"

  local items = {}
  for source_name, state in pairs(history_states) do
    -- SKIP the history picker itself
    if source_name ~= ignore_source then
      local last_input = (state.filter.pattern ~= "" and state.filter.pattern)
        or (state.filter.search ~= "" and state.filter.search)
        or nil

      table.insert(items, {
        text = source_name,
        source = source_name,
        added = state.added,
        display_pattern = last_input or "<empty>",
      })
    end
  end

  if #items == 0 then
    vim.notify("No picker history found", vim.log.levels.INFO)
    return
  end

  table.sort(items, function(a, b)
    return a.added > b.added
  end)

  Snacks.picker({
    source = ignore_source, -- Identify this picker so we can skip it next time
    title = "Picker History",
    finder = function()
      return items
    end,
    format = function(item, _)
      return {
        { item.source, "SnacksPickerMatch" },
        { "  |  ", "NonText" },
        { item.display_pattern, "Comment" },
      }
    end,
    actions = {
      confirm = function(picker, item)
        picker:close()
        if item then
          vim.schedule(function()
            resume_mod.resume(item.source)
          end)
        end
      end,
    },
    layout = { preset = "select" },
  })
end

return M
