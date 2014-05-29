@app.controller 'ProjectEditController', [ '$scope', '$http', '$upload', ($scope, $http, $upload)->

  $scope.init = (id)->
    $scope.project_id = id
    $http.get('/projects/' + id).success (res)->
      $scope.project = res

  $scope.open_head_edit = ()->
    if $scope.head_edited
      $scope.head_edited = false
      return
    $scope.head_edited = true
    $scope.head_edit = angular.copy($scope.project)
    $scope.head_edit.errors = null

  $scope.head_edit_submit = ()->
    $http
      url: '/projects/' + $scope.project_id
      method: 'PATCH'
      data:
        $scope.head_edit
    .success (res)->
      if res.success
        $scope.project = $scope.head_edit
        $scope.head_edited = false
      else
        $scope.head_edit.error_message = res.message
        $scope.head_edit.errors = res.errors

  $scope.upload_logo = ($files)->
    $scope.head_edit.logo_error = null
    for file in $files
      $scope.upload = $upload.upload
        url: '/logos'
        method: 'POST'
        file: file
      .success (res)->
        if res.success
          $scope.head_edit.logo_url = res.url
          $scope.head_edit.logo_id = res.id
        else
          $scope.head_edit.logo_error = res.message
      .error ()->
        console.log '上传失败'
  
  $scope.autocomplete_category = (viewValue)->
    $http
      url: '/categories/autocomplete'
      method: 'GET'
      params:
        search: viewValue
    .then (res)->
      res.data.data

  $scope.autocomplete_city = (viewValue)->
    $http
      url: '/cities/autocomplete'
      method: 'GET'
      params:
        search: viewValue
    .then (res)->
      res.data.data

  $scope.open_description_edit = ()->
    if $scope.description_edited
      $scope.description_edited = false
      return
    $scope.description_edited = true
    $scope.description_edit = $scope.project.description
  
  $scope.update_description = ()->
    $http
      url: '/projects/' + $scope.project_id + '/dirty_update'
      method: 'PATCH'
      data:
        description: $scope.description_edit
    .success (res)->
      if res.success
        $scope.project.description = $scope.description_edit
        $scope.description_edited = false
]
