float4 gColorTint : register(c92);
float gMotionBlur : register(c88);
float4 gRadius : register(c89);
float4 gTextureAnimation : register(c91);
bool gUseDirectional : register(b0);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	float3 r3;
	r0.xy = -0.5 + i.texcoord2.xy;
	if (gUseDirectional) {
		r1.xyz = normalize(i.texcoord1.xyz);
		r2 = gViewInverse[3].yzx + -i.texcoord.yzx;
		r3 = r1.zxy * r2.xyz;
		r2 = r1.yzx * r2.yzx + -r3.xyz;
		r3 = normalize(r2.xyz);
		r2 = gMotionBlur.xxx * i.texcoord1.xyz;
		r1.xyz = gRadius.xxx * r1.xyz + r2.xyz;
		r2 = r3.xyz * gRadius.xxx;
		r0.z = 0.7 + -i.texcoord2.y;
		r1.xyz = -r1.xyz * r0.zzz;
		r1.xyz = r0.xxx * r2.xyz + r1.xyz;
	} else {
		r2 = normalize(gViewInverse[0].xyz);
		r2 = r2.xyz * gRadius.xxx;
		r3 = normalize(-gViewInverse[1].xyz);
		r3 = r3.xyz * gRadius.xxx;
		r0.yzw = r0.yyy * r3.xyz;
		r1.xyz = r0.xxx * r2.xyz + r0.yzw;
	}
	r0.xyz = r1.xyz + i.texcoord.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	o.position = r0 + gWorldViewProj[3];
	r0.x = i.texcoord.w * gTextureAnimation.x + -gTextureAnimation.y;
	r0.y = frac(r0.x);
	r0.z = r0.x + -r0.y;
	r0.x = (r0.x < -r0.x) ? 1 : 0;
	r0.y = (-r0.y < r0.y) ? 1 : 0;
	r0.x = r0.x * r0.y + r0.z;
	r0.x = saturate(r0.x * gTextureAnimation.z);
	o.texcoord.x = gTextureAnimation.z * i.texcoord2.x + r0.x;
	o.color = gColorTint;
	o.texcoord.y = i.texcoord2.y;

	return o;
}
