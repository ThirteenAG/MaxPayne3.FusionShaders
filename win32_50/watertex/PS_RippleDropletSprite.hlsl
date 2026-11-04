struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float2 r0;
	r0 = i.texcoord.xy * float2(2, 2) + float2(-1, -1);
	r0.x = dot(r0.xy, r0.xy);
	r0.x = sqrt(r0.x);
	r0.x = saturate(r0.x * 1.10000002 + -0.100000001);
	r0.x = -(r0.x) + 1;
	r0.y = i.texcoord1 * 9.42477036;
	r0.y = sin(r0.y);
	r0.x = dot(r0.yy, r0.xx);
	o = r0.x + float4(0.5, 0.5, 0.5, 0.5);

	return o;
}
