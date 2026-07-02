if ."build-system"."build-backend" == "uv_build" then
  ."build-system".requires |= map(
    if test("^uv_build")
    then sub("^uv_build.*$"; "uv_build")
    else .
    end
  )
else
  .
end
