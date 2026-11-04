float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float specularColorFactor : register(c197);
float specularFactor : register(c196);

struct PS_IN
{
	float4 color : COLOR;
	float3 texcoord1 : TEXCOORD1;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	r0.x = saturate(-1 + i.color.x);
	o.color.xyz = r0.xxx * globalScalars2.zzz + i.color.xyz;
	r0.xyz = normalize(i.texcoord1.xyz);
	o.color1.xyz = r0.xyz * 0.5 + 0.5;
	r0.xw = float2(1, 0.0051020407);
	r0.y = saturate(r0.w * specularFactor.x);
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	r0.x = r0.x + -specularFactor.x;
	o.color2.y = (r0.x >= 0) ? 0.071428575 : r0.y;
	r0.x = globalScalars.x * i.color.w;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	o.color2.x = specularColorFactor.x;
	o.color2.z = i.color.x;
	r0.yz = float2(0, 1);
	o.color3 = r0.yyyz * gStencil.x;

	return o;
}
