donate_claims_give:
    type: command
    name: givedonate
    description: Utility command.
    usage: /givedonate
    permission: claims.givedonate
    script:
        - if <context.args.get[1].equals[group]>:
            - bungeeexecute "lpb user <context.args.get[2]> parent clear"
            - bungeeexecute "lpb user <context.args.get[2]> parent add <context.args.get[3]>"
        - else if <context.args.get[1].equals[group_remove]>:
            - bungeeexecute "lpb user <context.args.get[2]> parent remove <context.args.get[3]>"
        - else if <context.args.get[1].equals[item]>:
            - if !<server.has_flag[donate.claims.<context.args.get[2]>]>:
                - flag server donate.claims.<context.args.get[2]>:<map[]>

            - define claims <server.flag[donate.claims.<context.args.get[2]>]>

            - define item <context.args.get[3]>
            - define quantity <context.args.get[4]>

            - define claims_map <[claims].with[<[claims].size.add[1]>].as[<list[<[item]>|<[quantity]>]>]>

            - flag server donate.claims.<context.args.get[2]>:<[claims_map]>

            - if <server.match_player[<context.args.get[2]>].exists>:
                - define player <server.match_player[<context.args.get[2]>]>
                - inject donate_claim_task