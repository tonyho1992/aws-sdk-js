# Copyright 2012-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

helpers = require('../helpers')
AWS = helpers.AWS
MockClient = helpers.MockClient

describe 'AWS.Request', ->
  client = new MockClient

  describe 'createReadStream', ->
    it 'streams data', ->
      data = ''; done = false
      helpers.mockHttpResponse 200, {}, ['FOO', 'BAR', 'BAZ', 'QUX']

      runs ->
        request = client.makeRequest('mockMethod')
        s = request.createReadStream()
        s.on 'end', -> done = true
        s.on 'data', (c) -> data += c.toString()
      waitsFor -> done == true
      runs ->
        expect(data).toEqual('FOOBARBAZQUX')

