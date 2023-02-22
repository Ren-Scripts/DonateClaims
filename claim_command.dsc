donate_claim_config:
    type: data

    translation:
        prefix: <&5>Donate <&8>><&f>

        untaken_claims: You have untaken donate items!
        guide: Write <&n><element[/claim].on_click[/claim].on_hover[Click to see available items]><&r> to take them

        take: <&5>Take donate items

donate_claim_task:
    type: task
    debug: false

    script:
        - define translation <script[donate_claim_config].data_key[translation]>
        - define prefix <[translation].get[prefix].parsed>

        - narrate targets:<[player]> "<[prefix]> <[translation].get[untaken_claims].parsed>"
        - narrate targets:<[player]> "<[prefix]> <[translation].get[guide].parsed>"

donate_claim_command:
    type: command
    name: claim
    debug: false
    description: Claim donate.
    usage: /claim
    permissions: claims.claim
    script:
        - inventory open d:donate_claim_inventory

donate_claim_inventory:
    type: inventory
    debug: false
    inventory: hopper
    title: <script[donate_claim_config].data_key[translation].get[take].parsed>
    gui: true
    procedural items:
    - define list <list>
    - define items <server.flag[donate.claims.<player.name>]>

    - foreach <[items]>:
        - define item <item[<[value].get[1]>]>
        - adjust def:item quantity:<[value].get[2]>

        - define list:->:<[item]>
    - determine <[list]>

donate_claim_events:
    type: world
    debug: false
    events:
        on player joins:
            - if !<server.has_flag[donate.claims.<player.name>]>:
                - stop
            - if !<server.flag[donate.claims.<player.name>].is_empty>:
                - define player <player>
                - inject donate_claim_task
        on player clicks item in donate_claim_inventory:
            - inventory set d:<context.inventory> o:air slot:<context.slot>
            - give <context.item>

            - define items <server.flag[donate.claims.<player.name>]>

            - foreach <[items]>:
                - define item <item[<[value].get[1]>]>
                - adjust def:item quantity:<[value].get[2]>

                - if <[item].equals[<context.item>]>:
                    - flag server donate.claims.<player.name>:<server.flag[donate.claims.<player.name>].exclude[<[key]>]>
                    - foreach stop